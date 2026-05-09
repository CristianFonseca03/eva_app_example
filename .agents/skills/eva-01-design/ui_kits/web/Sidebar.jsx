/* global React */
const Sidebar = ({ activeId, onNavigate }) => {
  const sections = [
    {
      title: 'COMMAND',
      items: [
        { id: 'dashboard', icon: 'grid', label: 'OVERVIEW' },
        { id: 'detail',    icon: 'target', label: 'TARGET LOCK' },
        { id: 'comms',     icon: 'signal', label: 'COMMS', count: 3 },
      ]
    },
    {
      title: 'SUBSYSTEMS',
      items: [
        { id: 'propulsion', icon: 'terminal', label: 'PROPULSION' },
        { id: 'shield',     icon: 'shield',   label: 'AT FIELD' },
        { id: 'armory',     icon: 'lock',     label: 'ARMORY', locked: true },
      ]
    },
    {
      title: 'OPERATIONS',
      items: [
        { id: 'logs',   icon: 'terminal', label: 'EVENT LOG' },
        { id: 'alerts', icon: 'triangle-alert', label: 'ALERTS', alert: true },
        { id: 'clock',  icon: 'clock',    label: 'COUNTDOWN' },
      ]
    },
  ];

  return (
    <aside className="scroll" style={{
      background: '#0A0A0A',
      borderRight: '1px solid #3D1500',
      padding: '20px 0',
      display: 'flex', flexDirection: 'column', gap: 18,
    }}>
      {/* operator block */}
      <div style={{ padding: '0 16px 12px', borderBottom: '1px solid #3D1500' }}>
        <MicroLabel>[ OPERATOR ]</MicroLabel>
        <div style={{
          fontFamily: "'Bebas Neue', sans-serif", color: '#FF6B00',
          fontSize: 22, letterSpacing: '0.12em', paddingTop: 4,
        }}>IKARI · S</div>
        <div style={{
          fontFamily: "'Share Tech Mono', monospace", color: '#CC4400',
          fontSize: 10, letterSpacing: '0.15em', paddingTop: 2,
        }}>CLEARANCE · LV-3</div>
        <div style={{ paddingTop: 10 }}>
          <ProgressBar value={41.3} label="SYNC RATIO" level="sync" thin />
        </div>
      </div>

      {/* nav sections */}
      {sections.map(sec => (
        <div key={sec.title} style={{ display: 'flex', flexDirection: 'column' }}>
          <div style={{ padding: '0 16px 8px' }}>
            <MicroLabel>[ {sec.title} ]</MicroLabel>
          </div>
          {sec.items.map(it => {
            const active = it.id === activeId;
            return (
              <button key={it.id} onClick={() => !it.locked && onNavigate(it.id)}
                disabled={it.locked}
                style={{
                  display: 'flex', alignItems: 'center', gap: 10,
                  padding: '10px 16px',
                  background: active ? 'rgba(255,107,0,.08)' : 'transparent',
                  borderLeft: `3px solid ${active ? '#FF6B00' : 'transparent'}`,
                  borderTop: 0, borderRight: 0, borderBottom: 0,
                  color: it.locked ? '#333' : active ? '#fff' : '#FF6B00',
                  fontFamily: "'Rajdhani', sans-serif",
                  fontSize: 13, letterSpacing: '0.12em',
                  textTransform: 'uppercase', fontWeight: 600,
                  cursor: it.locked ? 'not-allowed' : 'pointer',
                  textAlign: 'left',
                  transition: 'all 150ms ease',
                  position: 'relative',
                }}>
                <Icon name={it.icon} size={16}
                  color={it.locked ? '#333' : active ? '#fff' : '#FF6B00'} />
                <span style={{ flex: 1 }}>{it.label}</span>
                {it.count !== undefined && (
                  <span style={{
                    width: 18, height: 18, background: '#FF2020', color: '#fff',
                    fontFamily: "'Share Tech Mono', monospace", fontSize: 10,
                    display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
                    boxShadow: '0 0 6px rgba(255,32,32,.6)',
                  }}>{it.count}</span>
                )}
                {it.alert && <Pip status="danger" pulse />}
                {it.locked && <span style={{fontSize:9}}>LOCKED</span>}
              </button>
            );
          })}
        </div>
      ))}
    </aside>
  );
};
window.Sidebar = Sidebar;
