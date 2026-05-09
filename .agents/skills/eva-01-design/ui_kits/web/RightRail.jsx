/* global React */
const RightRail = () => {
  const [feed, setFeed] = React.useState([
    { t: '12:45:30', code: 'INF', text: 'AT field engaged · CHN-14B' },
    { t: '12:45:24', code: 'WRN', text: 'Sync drift +0.4%' },
    { t: '12:45:18', code: 'INF', text: 'Cooling cycle complete' },
    { t: '12:45:02', code: 'INF', text: 'Ops console handshake OK' },
    { t: '12:44:51', code: 'ERR', text: 'CHN-09 timeout · retrying' },
    { t: '12:44:48', code: 'INF', text: 'Telemetry stream open' },
    { t: '12:44:30', code: 'INF', text: 'Pilot harness locked' },
  ]);

  // Append a new line every few seconds for realism
  React.useEffect(() => {
    const messages = [
      ['INF', 'Heartbeat OK'],
      ['WRN', 'Auxiliary fan throttled'],
      ['INF', 'Diagnostic ping received'],
      ['INF', 'Field telemetry cached'],
    ];
    const t = setInterval(() => {
      const m = messages[Math.floor(Math.random() * messages.length)];
      const time = new Date().toTimeString().slice(0,8);
      setFeed(f => [{ t: time, code: m[0], text: m[1] }, ...f].slice(0, 12));
    }, 4500);
    return () => clearInterval(t);
  }, []);

  const codeColor = c => c === 'ERR' ? '#FF2020' : c === 'WRN' ? '#FFB800' : '#FF6B00';

  return (
    <aside className="scroll" style={{
      background: '#0A0A0A',
      borderLeft: '1px solid #3D1500',
      padding: '18px 16px',
      display: 'flex', flexDirection: 'column', gap: 18,
    }}>
      <div>
        <MicroLabel>[ SYSTEM CLOCK ]</MicroLabel>
        <Clock />
      </div>

      <div>
        <MicroLabel>[ TELEMETRY · LIVE ]</MicroLabel>
        <div style={{
          marginTop: 8, fontFamily: "'Share Tech Mono', monospace",
          fontSize: 11, color: '#FF6B00', letterSpacing: '0.04em',
          maxHeight: 280, overflow: 'hidden',
        }}>
          {feed.map((line, i) => (
            <div key={`${line.t}-${i}`} style={{
              display: 'flex', gap: 8, padding: '4px 0',
              borderBottom: '1px solid rgba(255,107,0,.08)',
              opacity: 1 - i * 0.05,
            }}>
              <span style={{ color: '#666', minWidth: 60 }}>{line.t}</span>
              <span style={{ color: codeColor(line.code), minWidth: 28, fontWeight: 700 }}>{line.code}</span>
              <span style={{ color: line.code === 'ERR' ? '#FF2020' : '#FF6B00' }}>{line.text}</span>
            </div>
          ))}
        </div>
      </div>

      <div>
        <MicroLabel>[ COORDINATES ]</MicroLabel>
        <div style={{
          marginTop: 8, fontFamily: "'Share Tech Mono', monospace",
          fontSize: 12, color: '#fff', display: 'grid',
          gridTemplateColumns: '1fr 1fr', gap: 6,
        }}>
          <div>LAT</div><div style={{ color:'#fff', textAlign:'right' }}>+35.4536</div>
          <div>LON</div><div style={{ color:'#fff', textAlign:'right' }}>+139.6234</div>
          <div>ALT</div><div style={{ color:'#fff', textAlign:'right' }}>0024 m</div>
          <div>VEL</div><div style={{ color:'#FFB800', textAlign:'right' }}>014.7 m/s</div>
        </div>
      </div>
    </aside>
  );
};

const Clock = () => {
  const [now, setNow] = React.useState(new Date());
  React.useEffect(() => {
    const t = setInterval(() => setNow(new Date()), 1000);
    return () => clearInterval(t);
  }, []);
  return (
    <div style={{
      marginTop: 6,
      fontFamily: "'Share Tech Mono', monospace",
      fontSize: 28, color: '#fff', letterSpacing: '0.04em',
      textShadow: '0 0 8px rgba(255,107,0,.5)',
    }}>{now.toTimeString().slice(0,8)}</div>
  );
};

window.RightRail = RightRail;
