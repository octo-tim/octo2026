import { COOKIE_NAME, ONE_YEAR_MS } from "@shared/const";
import type { Express, Request, Response } from "express";
import mysql from "mysql2/promise";
import * as db from "../db";
import { getSessionCookieOptions } from "./cookies";
import { sdk, hashPassword, verifyPassword } from "./sdk";

// Direct MySQL connection for login (bypasses Drizzle ORM mapping issues)
async function getUserWithPassword(username: string) {
  const dbUrl = process.env.DATABASE_URL;
  if (!dbUrl) return null;
  
  let connection;
  try {
    connection = await mysql.createConnection(dbUrl);
    const [rows] = await connection.execute(
      'SELECT id, openId, name, role, passwordHash FROM users WHERE openId = ? LIMIT 1',
      [username]
    );
    const result = rows as any[];
    return result.length > 0 ? result[0] : null;
  } catch (error) {
    console.error("[Auth] DB query failed:", error);
    return null;
  } finally {
    if (connection) await connection.end();
  }
}

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

  // ── Login ──────────────────────────────────────────────────────────
  app.post("/api/auth/login", async (req: Request, res: Response) => {
    try {
      const { username, password } = req.body ?? {};
      if (!username || !password) {
        return res.status(400).json({ error: "username과 password는 필수입니다" });
      }

      const user = await getUserWithPassword(username);
      if (!user || !user.passwordHash) {
        return res.status(401).json({ error: "아이디 또는 비밀번호가 올바르지 않습니다" });
      }

      const valid = await verifyPassword(password, user.passwordHash);
      if (!valid) {
        return res.status(401).json({ error: "아이디 또는 비밀번호가 올바르지 않습니다" });
      }

      await db.upsertUser({ openId: user.openId, lastSignedIn: new Date() });

      const sessionToken = await sdk.createSessionToken(user.openId, {
        name: user.name || username,
        expiresInMs: ONE_YEAR_MS,
      });

      const cookieOptions = getSessionCookieOptions(req);
      res.cookie(COOKIE_NAME, sessionToken, { ...cookieOptions, maxAge: ONE_YEAR_MS });
      res.json({ success: true, user: { id: user.id, name: user.name, role: user.role } });
    } catch (error) {
      console.error("[Auth] Login failed", error);
      res.status(500).json({ error: "로그인에 실패했습니다" });
    }
  });
}
