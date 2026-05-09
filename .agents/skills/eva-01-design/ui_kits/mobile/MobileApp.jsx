/* global React, Button, HazardButton, MicroLabel, Pip, StatusBadge, TextInput, DataCard, ProgressBar, AlertPanel, Icon */
const { useState, useEffect } = React;

// =============================================================
// Phone shell — angular EVA bezel (not iOS chrome)
// =============================================================
const PhoneShell = ({ children }) => (
  <div style={{
    width: 390, height: 844,
    background: '#0A0A0A',
    border: '2px solid #3D1500',
    boxShadow: '0 0 40px rgba(255,107,0,.05), 0 20px 80px rgba(0,0,0,.9)',
    clipPath: 'polygon(0 16px, 16px 0, calc(100% - 16px) 0, 100% 16px, 100% calc(100% - 16px), calc(100% - 16px) 100%, 16px 100%, 0 calc(100% - 16px))',
    display: 'flex', flexDirection: 'column', overflow: 'hidden',
    position: 'relative',
  }}>
    {/* corner registration ticks */}
    {['tl','tr','bl','br'].map(p => (
      <span key={p} style={{
        position:'absolute', width:14, height:14,
        borderColor:'#FF6B00',
        borderStyle:'solid',
        borderWidth: p === 'tl' ? '1px 0 0 1px' : p === 'tr' ? '1px 1px 0 0' : p === 'bl' ? '0 0 1px 1px' : '0 1px 1px 0',
        top: p.startsWith('t') ? 6 : 'auto',
        bottom: p.startsWith('b') ? 6 : 'auto',
        left: p.endsWith('l') ? 6 : 'auto',
        right: p.endsWith('r') ? 6 : 'auto',
        zIndex: 10,
      }}/>
    ))}
    {children}
  </div>
);

// =============================================================
// Mobile status bar (system UI)
// =============================================================
const MobileStatusBar = () => {
  const [now, setNow] = useState(new Date());
  useEffect(() => { const t = setInterval(() => setNow(new Date()), 1000); return () => clearInterval(t); }, []);
  return (
    <div style={{
      display:'flex', justifyContent:'space-between', alignItems:'center',
      padding:'18px 24px 8px', height:36,
      fontFamily: "'Share Tech Mono', monospace", fontSize:11, color:'#FF6B00',
      letterSpacing:'.15em',
    }}>
      <span style={{ color:'#fff' }}>{now.toTimeString().slice(0,5)}</span>
      <span>NERV·OPS</span>
      <span style={{ display:'inline-flex', gap:6, alignItems:'center' }}>
        <span style={{ width:8, height:8, background:'#6BFF3B', boxShadow:'0 0 4px #6BFF3B' }}/>
        4G
        <span style={{
          width:18, height:9, border:'1px solid #FF6B00', position:'relative', display:'inline-block', marginLeft:2,
        }}>
          <span style={{ position:'absolute', inset:1, background:'#FF6B00', width:'70%' }}/>
        </span>
      </span>
    </div>
  );
};

// =============================================================
// Header — section title + breadcrumb
// =============================================================
const ScreenHeader = ({ crumb, title, action }) => (
  <div style={{ padding:'8px 20px 16px', borderBottom:'1px solid #3D1500', position:'relative' }}>
    <MicroLabel>{crumb}</MicroLabel>
    <div style={{
      display:'flex', justifyContent:'space-between', alignItems:'flex-end', paddingTop:4,
    }}>
      <h1 style={{
        fontFamily:"'Bebas Neue',sans-serif", color:'#FF6B00',
        fontSize:32, letterSpacing:'.14em', margin:0, lineHeight:1,
      }}>{title}</h1>
      {action}
    </div>
    {/* clipped decorative line */}
    <div style={{
      position:'absolute', bottom:-1, right:0, height:1, width:60,
      background:'#FF6B00',
      clipPath:'polygon(8px 0, 100% 0, 100% 100%, 0 100%)',
    }}/>
  </div>
);

// =============================================================
// Bottom tab bar
// =============================================================
const BottomTabBar = ({ active, onTab }) => {
  const tabs = [
    { id:'home', icon:'grid', label:'OPS' },
    { id:'form', icon:'terminal', label:'CMD' },
    { id:'alerts', icon:'triangle-alert', label:'ALERT', alert:true },
    { id:'profile', icon:'shield', label:'AUTH' },
  ];
  return (
    <nav style={{
      display:'flex', justifyContent:'space-around', alignItems:'flex-start',
      borderTop:'1px solid #3D1500', background:'#0A0A0A',
      paddingTop:8, paddingBottom:24, height:78, flexShrink:0,
    }}>
      {tabs.map(t => {
        const a = t.id === active;
        return (
          <button key={t.id} onClick={() => onTab(t.id)} style={{
            display:'flex', flexDirection:'column', gap:4, alignItems:'center',
            background:'transparent', border:0, padding:'4px 8px', cursor:'pointer',
            position:'relative', flex:1,
          }}>
            <Icon name={t.icon} size={22} color={a ? '#FF6B00' : '#666'} />
            <span style={{
              fontFamily:"'Share Tech Mono',monospace", fontSize:9,
              color: a ? '#FF6B00' : 'transparent',
              letterSpacing:'.18em',
            }}>{t.label}</span>
            {a && <span style={{ position:'absolute', bottom:-2, width:6, height:6, background:'#FF6B00', boxShadow:'0 0 6px #FF6B00' }}/>}
            {t.alert && <span style={{ position:'absolute', top:0, right:'25%', width:6, height:6, background:'#FF2020', boxShadow:'0 0 4px #FF2020' }}/>}
          </button>
        );
      })}
    </nav>
  );
};

// =============================================================
// SCREEN: Home
// =============================================================
const HomeScreen = ({ onOpenForm }) => (
  <div style={{ flex:1, overflowY:'auto', padding:'12px 16px 16px', display:'flex', flexDirection:'column', gap:12 }}>
    <StatusBadge status="danger">CORE BREACH IMMINENT</StatusBadge>

    <DataCard category="MISSION CLOCK" label="T-MINUS" value="00:01:47" status="danger">
      <div style={{ display:'flex', gap:6, alignItems:'center' }}><Pip status="danger" pulse/><MicroLabel color="#FF2020">ENGAGEMENT WINDOW</MicroLabel></div>
    </DataCard>

    <div style={{ display:'grid', gridTemplateColumns:'1fr 1fr', gap:10 }}>
      <DataCard category="SYNC RATIO" label="IKARI · S" value="41.3" unit="%" />
      <DataCard category="AT FIELD" label="STRENGTH" value="87.4" unit="%" />
    </div>

    <div style={{
      background:'#111', border:'1px solid #3D1500',
      borderTop:'2px solid #FF6B00',
      clipPath:'polygon(0 0, calc(100% - 12px) 0, 100% 12px, 100% 100%, 0 100%)',
      padding:'14px 14px 16px',
    }}>
      <MicroLabel>[ SUBSYSTEM INTEGRITY ]</MicroLabel>
      <div style={{ display:'flex', flexDirection:'column', gap:10, paddingTop:10 }}>
        <ProgressBar value={68} label="FUEL · OXIDIZER" />
        <ProgressBar value={92} label="CORE · 92% HAZARD" level="haz" />
        <ProgressBar value={14} label="SHIELD · CRITICAL" level="crit" />
      </div>
    </div>

    <div style={{
      background:'#111', border:'1px solid #3D1500',
      clipPath:'polygon(0 0, calc(100% - 12px) 0, 100% 12px, 100% 100%, 0 100%)',
      padding:'14px',
    }}>
      <MicroLabel>[ EVENT LOG ]</MicroLabel>
      <div style={{ fontFamily:"'Share Tech Mono',monospace", fontSize:11, color:'#FF6B00', paddingTop:8 }}>
        {[
          ['12:45:30','INF','#FF6B00','AT field engaged · CHN-14B'],
          ['12:45:24','WRN','#FFB800','Sync drift +0.4%'],
          ['12:44:51','ERR','#FF2020','CHN-09 timeout · retrying'],
          ['12:44:30','INF','#FF6B00','Pilot harness locked'],
        ].map(([t,c,col,m],i)=>(
          <div key={i} style={{ display:'flex', gap:6, padding:'3px 0', borderBottom:'1px solid rgba(255,107,0,.08)' }}>
            <span style={{ color:'#666' }}>{t}</span>
            <span style={{ color:col, fontWeight:700, minWidth:24 }}>{c}</span>
            <span style={{ color: c==='ERR' ? '#FF2020' : '#FF6B00' }}>{m}</span>
          </div>
        ))}
      </div>
    </div>

    {/* Rectangular FAB */}
    <button onClick={onOpenForm} style={{
      position:'fixed', right:24, bottom:96, zIndex:5,
      background:'#FF2020', color:'#fff', border:0, padding:'14px 18px',
      fontFamily:"'Rajdhani',sans-serif", fontSize:13, letterSpacing:'.12em',
      textTransform:'uppercase', fontWeight:700,
      clipPath:'polygon(0 0, calc(100% - 12px) 0, 100% 12px, 100% 100%, 0 100%)',
      boxShadow:'0 0 12px rgba(255,32,32,.6), 0 0 28px rgba(255,32,32,.3)',
      cursor:'pointer',
    }}>+ NEW DIRECTIVE</button>
  </div>
);

// =============================================================
// SCREEN: Form
// =============================================================
const FormScreen = ({ onSubmit }) => {
  const [op, setOp] = useState('IKARI-S-003');
  const [code, setCode] = useState('');
  const [system, setSystem] = useState('PROPULSION');
  const [confirm, setConfirm] = useState(false);
  const [override, setOverride] = useState(false);

  return (
    <div style={{ flex:1, overflowY:'auto', padding:'14px 18px 24px', display:'flex', flexDirection:'column', gap:16 }}>
      <div>
        <MicroLabel>[ FORM · OPERATOR DIRECTIVE ]</MicroLabel>
        <p style={{ fontFamily:"'Rajdhani',sans-serif", color:'#fff', fontSize:13, letterSpacing:'.04em', margin:'8px 0 0', lineHeight:1.5 }}>
          Transmit a directive to the active subsystem. All directives are logged and require operator clearance LV-3 or higher.
        </p>
      </div>

      <TextInput label="OPERATOR ID" value={op} onChange={e=>setOp(e.target.value)} />
      <TextInput label="DIRECTIVE CODE" value={code} placeholder="ENTER CODE" onChange={e=>setCode(e.target.value)} />

      <div>
        <MicroLabel color="#CC4400">[ SUBSYSTEM ]</MicroLabel>
        <div style={{
          background:'#111', color:'#FF6B00',
          padding:'10px 12px', borderBottom:'2px solid #FF6B00', marginTop:4,
          fontFamily:"'Share Tech Mono',monospace", fontSize:13,
          display:'flex', justifyContent:'space-between', alignItems:'center', letterSpacing:'.06em',
        }}>
          <span>{system}</span><span style={{ fontSize:9 }}>▼</span>
        </div>
      </div>

      <div style={{ display:'flex', flexDirection:'column', gap:14, paddingTop:4 }}>
        <MicroLabel color="#CC4400">[ INTERLOCKS ]</MicroLabel>
        <CheckRow label="CRYO LOCK" checked={confirm} onToggle={()=>setConfirm(!confirm)} />
        <CheckRow label="MANUAL OVERRIDE" checked={override} onToggle={()=>setOverride(!override)} danger />
      </div>

      <div style={{ display:'flex', flexDirection:'column', gap:10, paddingTop:8 }}>
        <Button variant="secondary" size="lg" onClick={onSubmit}>SUBMIT DIRECTIVE</Button>
        <Button variant="ghost" size="md">CANCEL</Button>
      </div>
    </div>
  );
};

const CheckRow = ({ label, checked, onToggle, danger }) => (
  <button onClick={onToggle} style={{
    display:'flex', gap:10, alignItems:'center', background:'transparent',
    border:0, padding:'6px 0', cursor:'pointer', textAlign:'left',
  }}>
    <span style={{
      width:20, height:20,
      border: `1.5px solid ${danger ? '#FF2020' : '#FF6B00'}`,
      background: checked ? (danger ? '#FF2020' : '#FF6B00') : 'transparent',
      display:'inline-flex', alignItems:'center', justifyContent:'center',
      flexShrink: 0,
    }}>
      {checked && <span style={{
        width:8, height:5, borderLeft:'2px solid #000', borderBottom:'2px solid #000',
        transform:'rotate(-45deg) translate(1px,-1px)',
      }}/>}
    </span>
    <span style={{
      fontFamily:"'Rajdhani',sans-serif", textTransform:'uppercase',
      letterSpacing:'.1em', fontSize:13, fontWeight:600,
      color: danger ? '#FF2020' : '#FF6B00',
    }}>{label}</span>
  </button>
);

// =============================================================
// SCREEN: Alerts
// =============================================================
const AlertsScreen = ({ onPurge }) => (
  <div style={{ flex:1, overflowY:'auto', padding:'14px 16px 24px', display:'flex', flexDirection:'column', gap:12 }}>
    <AlertPanel level="danger" code="ERR-7740 · CORE BREACH">
      Reactor delta has exceeded safe threshold. Initiate shutdown within <b style={{color:'#FF2020', fontFamily:"'Share Tech Mono'"}}>00:01:47</b>.
    </AlertPanel>
    <AlertPanel level="warn" code="WRN-2102 · SYNC DRIFT">
      Pilot sync ratio fluctuating outside nominal band. Recalibrate before next sortie.
    </AlertPanel>
    <AlertPanel level="warn" code="WRN-1080 · COOLANT LOOP-B">
      Auxiliary coolant pressure dropping. Loop-A stable.
    </AlertPanel>
    <div style={{
      background:'#111', border:'1px solid #3D1500',
      borderTop:'2px solid #FF2020',
      clipPath:'polygon(0 0, calc(100% - 12px) 0, 100% 12px, 100% 100%, 0 100%)',
      padding:'14px',
    }}>
      <MicroLabel>[ EMERGENCY RESPONSE ]</MicroLabel>
      <p style={{
        fontFamily:"'Rajdhani',sans-serif", color:'#fff', fontSize:13,
        letterSpacing:'.04em', margin:'8px 0 14px', lineHeight:1.5,
      }}>
        Auxiliary core can be purged to recover 70% of remaining mission window. <b style={{color:'#FF2020'}}>Action is irreversible.</b>
      </p>
      <HazardButton onClick={onPurge}>⚠&nbsp; PURGE CORE</HazardButton>
    </div>
  </div>
);

// =============================================================
// SCREEN: Auth (placeholder profile)
// =============================================================
const AuthScreen = () => (
  <div style={{ flex:1, padding:'18px 18px', display:'flex', flexDirection:'column', gap:14 }}>
    <MicroLabel>[ OPERATOR PROFILE ]</MicroLabel>
    <div style={{ fontFamily:"'Bebas Neue',sans-serif", color:'#FF6B00', fontSize:36, letterSpacing:'.14em', lineHeight:1 }}>IKARI · S</div>
    <div style={{ fontFamily:"'Share Tech Mono',monospace", color:'#CC4400', fontSize:11, letterSpacing:'.18em' }}>CLEARANCE · LV-3 · CHN-14B</div>
    <ProgressBar value={41.3} label="SYNC RATIO" level="sync" thin />
    <ProgressBar value={88} label="HEALTH" />
    <ProgressBar value={67} label="MISSION CREDIBILITY" />
    <div style={{ height:1, background:'#3D1500', margin:'4px 0' }}/>
    <Button variant="secondary" size="lg">EXPORT TELEMETRY</Button>
    <Button variant="danger" size="md">SIGN OUT</Button>
  </div>
);

// =============================================================
// Hazard modal (mobile)
// =============================================================
const HazardModal = ({ onClose, onExecute }) => {
  const [text, setText] = useState('');
  return (
    <div style={{
      position:'absolute', inset:0, background:'rgba(0,0,0,.85)',
      display:'flex', alignItems:'center', justifyContent:'center', padding:18, zIndex:30,
    }}>
      <div style={{
        background:'#0A0A0A', border:'2px solid #FF2020',
        boxShadow:'0 0 24px rgba(255,32,32,.5)',
        clipPath:'polygon(0 0, calc(100% - 12px) 0, 100% 12px, 100% 100%, 12px 100%, 0 calc(100% - 12px))',
        width:'100%',
      }}>
        <div style={{ padding:'12px 14px', background:'rgba(255,32,32,.1)', borderBottom:'1px solid #3D1500', display:'flex', gap:10, alignItems:'center' }}>
          <Icon name="triangle-alert" size={18} color="#FF2020"/>
          <span style={{ fontFamily:"'Bebas Neue',sans-serif", color:'#FF2020', fontSize:18, letterSpacing:'.14em' }}>CONFIRM IRREVERSIBLE</span>
        </div>
        <div style={{ padding:14, color:'#fff', fontFamily:"'Rajdhani',sans-serif", fontSize:13, letterSpacing:'.04em', lineHeight:1.5 }}>
          You are about to <code style={{color:'#FF2020', fontFamily:"'Share Tech Mono'"}}>PURGE</code> the auxiliary core. This cannot be undone.
          <div style={{ paddingTop:10 }}>
            <MicroLabel color="#CC4400">[ TYPE "PURGE" ]</MicroLabel>
            <input value={text} onChange={e=>setText(e.target.value)} style={{
              background:'#111', border:0, borderBottom:'2px solid #FF2020',
              color:'#fff', fontFamily:"'Share Tech Mono',monospace", fontSize:14,
              padding:'8px 10px', width:'100%', letterSpacing:'.1em', outline:'none', marginTop:6,
            }}/>
          </div>
        </div>
        <div style={{ padding:'12px 14px', borderTop:'1px solid #3D1500', display:'flex', gap:8, justifyContent:'flex-end' }}>
          <Button variant="secondary" size="sm" onClick={onClose}>CANCEL</Button>
          <button onClick={()=>{ if(text==='PURGE') onExecute(); }} disabled={text!=='PURGE'} style={{
            background: text === 'PURGE' ? 'repeating-linear-gradient(45deg,#FFB800 0,#FFB800 8px,#1A1A00 8px,#1A1A00 16px)' : '#1A0800',
            border:0, height:28, padding:0, opacity: text === 'PURGE' ? 1 : .5,
            clipPath:'polygon(0 0, calc(100% - 8px) 0, 100% 8px, 100% 100%, 0 100%)',
            cursor: text==='PURGE' ? 'pointer' : 'not-allowed',
          }}>
            <span style={{
              display:'inline-flex', alignItems:'center', height:'100%', padding:'0 12px',
              background:'rgba(0,0,0,.7)', color:'#fff',
              fontFamily:"'Rajdhani',sans-serif", fontWeight:700,
              letterSpacing:'.12em', textTransform:'uppercase', fontSize:11,
            }}>EXECUTE</span>
          </button>
        </div>
      </div>
    </div>
  );
};

// =============================================================
// MobileApp root
// =============================================================
const MobileApp = () => {
  const [screen, setScreen] = useState('home');
  const [showModal, setShowModal] = useState(false);

  const titles = {
    home:    { crumb: '[ NERV / OPS / OVERVIEW ]',   title: 'OPS' },
    form:    { crumb: '[ NERV / CMD / DIRECTIVE ]',  title: 'NEW DIRECTIVE' },
    alerts:  { crumb: '[ NERV / OPS / ALERTS ]',     title: 'ALERTS' },
    profile: { crumb: '[ NERV / AUTH / OPERATOR ]',  title: 'AUTH' },
  };
  const t = titles[screen] || titles.home;

  return (
    <PhoneShell>
      <MobileStatusBar />
      <ScreenHeader crumb={t.crumb} title={t.title}
        action={<StatusBadge status={screen==='alerts' ? 'danger' : 'standby'}>{screen==='alerts'?'3 OPEN':'LV-3'}</StatusBadge>} />
      {screen === 'home'    && <HomeScreen   onOpenForm={() => setScreen('form')} />}
      {screen === 'form'    && <FormScreen   onSubmit={() => setScreen('home')} />}
      {screen === 'alerts'  && <AlertsScreen onPurge={() => setShowModal(true)} />}
      {screen === 'profile' && <AuthScreen />}
      <BottomTabBar active={screen} onTab={s => setScreen(s === 'profile' ? 'profile' : s)} />
      {showModal && <HazardModal onClose={()=>setShowModal(false)} onExecute={()=>setShowModal(false)} />}
    </PhoneShell>
  );
};
window.MobileApp = MobileApp;
