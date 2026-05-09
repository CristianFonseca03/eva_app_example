/* global React */
const TopBar = () => {
  const [time, setTime] = React.useState(new Date());
  React.useEffect(() => {
    const t = setInterval(() => setTime(new Date()), 1000);
    return () => clearInterval(t);
  }, []);
  const fmt = time.toTimeString().slice(0,8);

  return (
    <header style={{
      display: 'flex', alignItems: 'center', height: 56,
      background: '#000', borderBottom: '1px solid #3D1500',
      padding: '0 24px', gap: 24,
    }}>
      {/* Logo block */}
      <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
        <div style={{
          width: 28, height: 28, position: 'relative',
          clipPath: 'polygon(0 0, 24px 0, 28px 4px, 28px 28px, 4px 28px, 0 24px)',
          background: '#FF6B00',
        }}>
          <span style={{
            position: 'absolute', inset: 1,
            background: '#000', display: 'flex', alignItems: 'center', justifyContent: 'center',
            fontFamily: "'Bebas Neue', sans-serif", fontSize: 16, color: '#FF6B00',
            letterSpacing: '0.05em', clipPath: 'inherit',
          }}>E1</span>
        </div>
        <div>
          <div style={{
            fontFamily: "'Bebas Neue', sans-serif", color: '#FF6B00',
            fontSize: 20, letterSpacing: '0.18em', lineHeight: 1,
          }}>NERV / OPS CONSOLE</div>
          <div style={{
            fontFamily: "'Share Tech Mono', monospace", fontSize: 9,
            color: '#666', letterSpacing: '0.18em',
          }}>EVA-01 · CMD-LINE-3 · CHN-14B</div>
        </div>
      </div>

      {/* Breadcrumb / status text */}
      <div style={{ flex: 1 }}/>

      <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
        <StatusBadge status="active">SYS NOMINAL</StatusBadge>
        <StatusBadge status="standby">3 ALERTS</StatusBadge>
        <div style={{
          fontFamily: "'Share Tech Mono', monospace", color: '#fff',
          fontSize: 16, letterSpacing: '0.05em', minWidth: 86,
          textShadow: '0 0 8px rgba(255,107,0,.4)',
        }}>{fmt}</div>
        <Icon name="signal" size={20} color="#FF6B00" />
        <Icon name="lock" size={20} color="#FF6B00" />
        <div style={{
          width: 1, height: 24, background: '#3D1500',
        }}/>
        <span style={{
          fontFamily: "'Share Tech Mono', monospace", color: '#FF6B00',
          fontSize: 11, letterSpacing: '0.15em',
        }}>OP. IKARI-S-003</span>
      </div>
    </header>
  );
};
window.TopBar = TopBar;
