/* global React */
const Dashboard = ({ goDetail }) => {
  return (
    <main className="scroll" style={{ padding: 24, display: 'flex', flexDirection: 'column', gap: 24, position: 'relative' }}>
      {/* scan-line decoration */}
      <div style={{
        position: 'absolute', inset: 0, pointerEvents: 'none',
        backgroundImage: 'repeating-linear-gradient(0deg, rgba(255,107,0,.025) 0, rgba(255,107,0,.025) 1px, transparent 1px, transparent 3px)',
      }}/>

      {/* header row */}
      <div style={{ display: 'flex', alignItems: 'flex-end', justifyContent: 'space-between' }}>
        <div>
          <MicroLabel>[ NERV / OPERATIONS / OVERVIEW ]</MicroLabel>
          <h1 style={{
            fontFamily: "'Bebas Neue', sans-serif", color: '#FF6B00',
            fontSize: 40, letterSpacing: '0.18em', margin: '6px 0 0',
          }}>OPERATIONS CONSOLE</h1>
          <div style={{
            fontFamily: "'Rajdhani', sans-serif", color: '#CC4400',
            fontSize: 14, letterSpacing: '0.08em', textTransform: 'uppercase', paddingTop: 4,
          }}>System status — live · Last sync 00:00:04 ago</div>
        </div>
        <div style={{ display: 'flex', gap: 10 }}>
          <Button variant="ghost" icon={<Icon name="terminal" size={14} color="#666"/>}>EXPORT LOG</Button>
          <Button variant="secondary" icon={<Icon name="target" size={14} color="#FF6B00"/>}
            onClick={goDetail}>OPEN TARGET</Button>
        </div>
      </div>

      {/* alerts */}
      <AlertPanel level="danger" code="ERR-7740 · CORE BREACH IMMINENT">
        Reactor delta has exceeded safe threshold. Initiate emergency shutdown within&nbsp;
        <b style={{color:'#FF2020', fontFamily:"'Share Tech Mono'"}}>00:01:47</b>.
      </AlertPanel>

      {/* Top KPI cards */}
      <div style={{ display:'grid', gridTemplateColumns:'repeat(4,1fr)', gap:12 }}>
        <DataCard category="AT FIELD" label="FIELD STRENGTH" value="87.4" unit="%">
          <div style={{ display:'flex', gap:6, alignItems:'center' }}><Pip status="active"/><MicroLabel color="#6BFF3B">NOMINAL</MicroLabel></div>
        </DataCard>
        <DataCard category="SYNC" label="PILOT · UNIT-01" value="41.3" unit="%">
          <div style={{ display:'flex', gap:6, alignItems:'center' }}><Pip status="standby"/><MicroLabel color="#FFB800">DRIFT +0.4</MicroLabel></div>
        </DataCard>
        <DataCard category="CORE TEMP" label="REACTOR DELTA" value="+2147" status="danger">
          <div style={{ display:'flex', gap:6, alignItems:'center' }}><Pip status="danger" pulse/><MicroLabel color="#FF2020">CRITICAL</MicroLabel></div>
        </DataCard>
        <DataCard category="COMMS" label="UPLINK · CHN-14B" value="1.21" unit="GB/s">
          <div style={{ display:'flex', gap:6, alignItems:'center' }}><Pip status="active"/><MicroLabel color="#6BFF3B">STREAMING</MicroLabel></div>
        </DataCard>
      </div>

      {/* Two-up: subsystem grid + status panel */}
      <div style={{ display:'grid', gridTemplateColumns:'1.4fr 1fr', gap:12 }}>
        {/* Subsystems gauge */}
        <div style={{
          background: '#111', border: '1px solid #3D1500',
          clipPath: 'polygon(0 0, calc(100% - 12px) 0, 100% 12px, 100% 100%, 0 100%)',
          padding: 18, display:'flex', flexDirection:'column', gap:14,
        }}>
          <div style={{ display:'flex', justifyContent:'space-between', alignItems:'baseline' }}>
            <div>
              <MicroLabel>[ SUBSYSTEMS ]</MicroLabel>
              <div style={{
                fontFamily:"'Bebas Neue',sans-serif", color:'#FF6B00',
                fontSize:22, letterSpacing:'.15em', paddingTop:4,
              }}>RESOURCE INTEGRITY</div>
            </div>
            <StatusBadge status="warning">3 BELOW NOMINAL</StatusBadge>
          </div>
          <ProgressBar value={68} label="FUEL · OXIDIZER" />
          <ProgressBar value={92} label="CORE TEMP · 92% HAZARD" level="haz" />
          <ProgressBar value={14} label="SHIELD INTEGRITY · CRITICAL" level="crit" />
          <ProgressBar value={73} label="COOLANT · LOOP-A" />
          <ProgressBar value={41.3} label="SYNC RATIO · IKARI-S" level="sync" thin />
          <ProgressBar value={88} label="POWER · UMBILICAL" />
        </div>

        {/* Status panel grid */}
        <div style={{
          background: '#111', border: '1px solid #3D1500',
          clipPath: 'polygon(0 0, calc(100% - 12px) 0, 100% 12px, 100% 100%, 0 100%)',
          padding: 18, display:'flex', flexDirection:'column', gap:14,
        }}>
          <div>
            <MicroLabel>[ MISSION STATUS ]</MicroLabel>
            <div style={{
              fontFamily:"'Bebas Neue',sans-serif", color:'#FF6B00',
              fontSize:22, letterSpacing:'.15em', paddingTop:4,
            }}>T-MINUS COUNTDOWN</div>
          </div>
          <div style={{
            fontFamily:"'Share Tech Mono',monospace", color:'#fff',
            fontSize:48, letterSpacing:'.02em',
            textShadow:'0 0 12px rgba(255,107,0,.5)',
          }}>00:01:47</div>
          <div style={{ display:'grid', gridTemplateColumns:'1fr 1fr', gap:12 }}>
            <Telem k="TARGET" v="ANGEL-14" c="#FF2020" />
            <Telem k="DISTANCE" v="14.7 KM" c="#fff" />
            <Telem k="VECTOR" v="045°" c="#fff" />
            <Telem k="THREAT" v="LV-EX" c="#FF2020" />
            <Telem k="ETA" v="00:01:47" c="#FFB800" />
            <Telem k="WEAPON" v="POSITRON" c="#fff" />
          </div>
          <div style={{ display:'flex', gap:10, marginTop:'auto' }}>
            <Button variant="primary" size="md">ENGAGE</Button>
            <Button variant="danger" size="md">ABORT</Button>
          </div>
        </div>
      </div>

      {/* footer signature line */}
      <div style={{
        height: 1, marginTop: 4,
        background: 'linear-gradient(90deg, #FF6B00, transparent 40%, #3D1500 60%, transparent)',
      }}/>
    </main>
  );
};

const Telem = ({ k, v, c = '#FF6B00' }) => (
  <div style={{ display:'flex', flexDirection:'column', gap:2 }}>
    <MicroLabel>{k}</MicroLabel>
    <div style={{ fontFamily:"'Share Tech Mono',monospace", fontSize:18, color:c, fontWeight:700 }}>{v}</div>
  </div>
);

window.Dashboard = Dashboard;
