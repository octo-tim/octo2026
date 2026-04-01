import { COOKIE_NAME, ONE_YEAR_MS } from "@shared/const";
import type { Express, Request, Response } from "express";
import { sql } from "drizzle-orm";
import * as db from "../db";
import { getSessionCookieOptions } from "./cookies";
import { sdk, hashPassword, verifyPassword } from "./sdk";

export function registerOAuthRoutes(app: Express) {
  // ── Register ───────────────────────────────────────────────────────
  app.post("/api/auth/register", async (req: Request, res: Response) => {
    try {
      const { username, password, name } = req.body ?? {};
      if (!username || !password) {
        return res.status(400).json({ error: "username과 password는 필수입니다" });
      }

      const existing = await db.getUserByOpenId(username);
      if (existing) {
        return res.status(409).json({ error: "이미 존재하는 사용자입니다" });
      }

      const hashed = await hashPassword(password);

      await db.upsertUser({
        openId: username,
        passwordHash: hashed,
        name: name || username,
        email: null,
        loginMethod: "password",
        lastSignedIn: new Date(),
      });

      const sessionToken = await sdk.createSessionToken(username, {
        name: name || username,
        expiresInMs: ONE_YEAR_MS,
      });

      const cookieOptions = getSessionCookieOptions(req);
      res.cookie(COOKIE_NAME, sessionToken, { ...cookieOptions, maxAge: ONE_YEAR_MS });
      res.json({ success: true });
    } catch (error) {
      console.error("[Auth] Register failed", error);
      res.status(500).json({ error: "회원가입에 실패했습니다" });
    }
  });

  // ── Change Password ─────────────────────────────────────────────
  app.post("/api/auth/change-password", async (req: Request, res: Response) => {
    try {
      const { username, newPassword } = req.body ?? {};
      if (!username || !newPassword) {
        return res.status(400).json({ error: "username과 newPassword는 필수입니다" });
      }

      const user = await db.getUserByOpenId(username);
      if (!user) {
        return res.status(404).json({ error: "사용자를 찾을 수 없습니다" });
      }

      const hashed = await hashPassword(newPassword);
      const drizzleDb = await db.getDb();
      if (!drizzleDb) {
        return res.status(500).json({ error: "데이터베이스에 연결할 수 없습니다" });
      }
      await drizzleDb.execute(
        sql`UPDATE users SET passwordHash = ${hashed}, updatedAt = NOW() WHERE openId = ${username}`
      );

      res.json({ success: true, message: "비밀번호가 변경되었습니다" });
    } catch (error) {
      console.error("[Auth] Change password failed", error);
      res.status(500).json({ error: "비밀번호 변경에 실패했습니다" });
    }
  });

  // ── Login ──────────────────────────────────────────────────────────
  app.post("/api/auth/login", async (req: Request, res: Response) => {
    try {
      const { username, password } = req.body ?? {};
      if (!username || !password) {
        return res.status(400).json({ error: "username과 password는 필수입니다" });
      }

      // Use Drizzle's raw SQL to get passwordHash (bypasses schema column mapping)
      const drizzleDb = await db.getDb();
      if (!drizzleDb) {
        return res.status(500).json({ error: "데이터베이스에 연결할 수 없습니다" });
      }

      const result = await drizzleDb.execute(
        sql`SELECT id, openId, name, role, passwordHash FROM users WHERE openId = ${username} LIMIT 1`
      );
      
      // drizzle execute returns [rows, fields] for mysql2
      const rows = Array.isArray(result) ? result[0] : result;
      const user = Array.isArray(rows) ? rows[0] : rows;
      
      if (!user || !(user as any).passwordHash) {
        console.log("[Auth] Login: no user or no passwordHash", { username, user: user ? 'found' : 'null', hash: (user as any)?.passwordHash ? 'exists' : 'null' });
        return res.status(401).json({ error: "아이디 또는 비밀번호가 올바르지 않습니다" });
      }

      const valid = await verifyPassword(password, (user as any).passwordHash);
      if (!valid) {
        return res.status(401).json({ error: "아이디 또는 비밀번호가 올바르지 않습니다" });
      }

      await db.upsertUser({ openId: (user as any).openId, lastSignedIn: new Date() });

      const sessionToken = await sdk.createSessionToken((user as any).openId, {
        name: (user as any).name || username,
        expiresInMs: ONE_YEAR_MS,
      });

      const cookieOptions = getSessionCookieOptions(req);
      res.cookie(COOKIE_NAME, sessionToken, { ...cookieOptions, maxAge: ONE_YEAR_MS });
      res.json({ success: true, user: { id: (user as any).id, name: (user as any).name, role: (user as any).role } });
    } catch (error) {
      console.error("[Auth] Login failed", error);
      res.status(500).json({ error: "로그인에 실패했습니다: " + (error as Error).message });
    }
  });
}
