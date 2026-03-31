export const ENV = {
  appId: "octo2026",
  cookieSecret: process.env.JWT_SECRET ?? "change-me-in-production",
  databaseUrl: process.env.DATABASE_URL ?? "",
  ownerOpenId: process.env.OWNER_OPEN_ID ?? "",
  isProduction: process.env.NODE_ENV === "production",
  forgeApiUrl: "",
  forgeApiKey: "",
  ecountComCode: process.env.ECOUNT_COM_CODE ?? "",
  ecountUserId: process.env.ECOUNT_USER_ID ?? "",
  ecountApiCertKey: process.env.ECOUNT_API_CERT_KEY ?? "",
};
