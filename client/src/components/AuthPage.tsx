import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { ClipboardList, LogIn, UserPlus } from 'lucide-react';
import { useState } from 'react';

export function AuthPage() {
  const [isRegister, setIsRegister] = useState(false);
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [name, setName] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      const endpoint = isRegister ? '/api/auth/register' : '/api/auth/login';
      const body: Record<string, string> = { username, password };
      if (isRegister && name) body.name = name;

      const res = await fetch(endpoint, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'include',
        body: JSON.stringify(body),
      });

      const data = await res.json();
      if (!res.ok) {
        setError(data.error || '요청에 실패했습니다');
        return;
      }

      window.location.href = '/dashboard';
    } catch {
      setError('서버에 연결할 수 없습니다');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-background">
      <div className="w-full max-w-md px-8">
        <div className="text-center mb-10">
          <div className="w-16 h-16 rounded-xl bg-primary/10 flex items-center justify-center mx-auto mb-6">
            <ClipboardList className="w-8 h-8 text-primary" />
          </div>
          <h1 className="text-2xl font-semibold text-foreground tracking-tight mb-2">
            업무관리 시스템
          </h1>
          <p className="text-muted-foreground">Task Management System</p>
        </div>

        <form onSubmit={handleSubmit}>
          <div className="bg-card border border-border rounded-sm p-8 shadow-sm space-y-4">
            <div className="text-center mb-2">
              <h2 className="text-lg font-medium text-foreground">
                {isRegister ? '회원가입' : '로그인'}
              </h2>
            </div>

            {isRegister && (
              <div className="space-y-1.5">
                <Label htmlFor="name">이름</Label>
                <Input id="name" value={name} onChange={e => setName(e.target.value)} placeholder="표시될 이름" />
              </div>
            )}

            <div className="space-y-1.5">
              <Label htmlFor="username">아이디</Label>
              <Input id="username" value={username} onChange={e => setUsername(e.target.value)} placeholder="사용자 아이디" required />
            </div>

            <div className="space-y-1.5">
              <Label htmlFor="password">비밀번호</Label>
              <Input id="password" type="password" value={password} onChange={e => setPassword(e.target.value)} placeholder="비밀번호" required />
            </div>

            {error && <p className="text-sm text-destructive text-center">{error}</p>}

            <Button type="submit" className="w-full h-11 gap-2" disabled={loading}>
              {isRegister ? <UserPlus className="w-4 h-4" /> : <LogIn className="w-4 h-4" />}
              {loading ? '처리 중...' : isRegister ? '회원가입' : '로그인'}
            </Button>

            <p className="text-xs text-muted-foreground text-center mt-2">
              {isRegister ? (
                <>이미 계정이 있으신가요?{' '}
                  <button type="button" onClick={() => { setIsRegister(false); setError(''); }} className="text-primary underline">로그인</button>
                </>
              ) : (
                <>계정이 없으신가요?{' '}
                  <button type="button" onClick={() => { setIsRegister(true); setError(''); }} className="text-primary underline">회원가입</button>
                </>
              )}
            </p>
          </div>
        </form>

        <p className="text-xs text-muted-foreground text-center mt-8">© 2026 Task Manager. All rights reserved.</p>
      </div>
    </div>
  );
}
