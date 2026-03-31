// Manus types removed — self-hosted auth uses JWT only.
// Kept as empty module to avoid broken imports during transition.

export interface ExchangeTokenRequest { [key: string]: unknown; }
export interface ExchangeTokenResponse { accessToken: string; [key: string]: unknown; }
export interface GetUserInfoResponse { openId: string; name: string; email?: string | null; platform?: string | null; loginMethod?: string | null; projectId: string; }
export interface GetUserInfoWithJwtRequest { jwtToken: string; projectId: string; }
export interface GetUserInfoWithJwtResponse { openId: string; name: string; email?: string | null; platform?: string | null; loginMethod?: string | null; projectId: string; }
