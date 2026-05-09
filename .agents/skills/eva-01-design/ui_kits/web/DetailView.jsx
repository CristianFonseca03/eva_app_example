/* global React */
const DetailView = ({ goDashboard }) => {
  const [showModal, setShowModal] = React.useState(false);
  const [confirm, setConfirm] = React.useState('');

  return (
    <main className="scroll" style={{ padding: 24, display:'flex', flexDirection:'column', gap: 20 }}>
      {/* breadcrumb */}
      <div style={{ display:'flex', alignItems:'center', gap:8 }}>
        <span style={{
          fontFamily:"'Share Tech Mono',monospace", fontSize:10, color:'#666',
          letterSpacing:'.18em', textTransform:'uppercase',
        }}>NERV / OPERATIONS / </span>
        <span style={{
          fontFamily:"'Share Tech Mono',monospace", fontSize:10, color:'#FF6B00',
          letterSpacing:'.18em', textTransform:'uppercase',
        }}>TARGET LOCK</span>
      </div>

      {/* title row */}
      <div style={{ display:'flex', justifyContent:'space-between', alignItems:'flex-end', borderBottom:'1px dashed rgba(255,107,0,.3)', paddingBottom: 12 }}>
        <div>
          <h1 style={{
            fontFamily: "'Bebas Neue', sans-serif", color: '#FF6B00',
            fontSize: 48, letterSpacing: '0.16em', margin: 0,
          }}>ANGEL-14 · LOCK</h1>
          <div style={{
            fontFamily:"'Share Tech Mono',monospace", color:'#CC4400',
            fontSize:11, letterSpacing:'.18em', paddingTop:6,
          }}>IL-AREA / TSUNAMI / 27.2 BR · DESIGNATION CHN-14B</div>
        </div>
        <StatusBadge status="danger">DANGER</StatusBadge>
      </div>

      {/* Two-column: target dossier + action panel */}
      <div style={{ display:'grid', gridTemplateColumns:'2fr 1fr', gap:14 }}>
        <div style={{
          background:'#111', border:'1px solid #3D1500',
          clipPath:'polygon(0 0, calc(100% - 12px) 0, 100% 12px, 100% 100%, 0 100%)',
          padding:18,
        }}>
          <MicroLabel>[ TARGET DOSSIER ]</MicroLabel>
          <div style={{ display:'grid', gridTemplateColumns:'1fr 1fr 1fr', gap:14, marginTop:10 }}>
            <Telem k="CLASS" v="ANGEL" />
            <Telem k="DESIGN." v="14-TH" />
            <Telem k="STATE" v="ACTIVE" c="#FF2020" />
            <Telem k="MASS" v="2.3e6 KG" c="#fff" />
            <Telem k="HEAT" v="+413 K" c="#fff" />
            <Telem k="AT-FIELD" v="LV-EX" c="#FF2020" />
          </div>

          <div style={{ height:1, margin:'18px 0', background:'repeating-linear-gradient(90deg,#FF6B00 0,#FF6B00 4px,transparent 4px,transparent 8px)', opacity:.3 }}/>

          <MicroLabel>[ TRAJECTORY MAP · SCHEMATIC ]</MicroLabel>
          <div style={{ position:'relative', height:200, marginTop:8, background:'#0A0A0A', border:'1px solid #3D1500', overflow:'hidden' }}>
            {/* scan-line */}
            <div style={{
              position:'absolute', inset:0,
              backgroundImage:
                'repeating-linear-gradient(0deg, rgba(255,107,0,.04) 0, rgba(255,107,0,.04) 1px, transparent 1px, transparent 4px), repeating-linear-gradient(90deg, rgba(255,107,0,.04) 0, rgba(255,107,0,.04) 1px, transparent 1px, transparent 4px)',
            }}/>
            {/* center crosshair */}
            <svg viewBox="0 0 400 200" preserveAspectRatio="none" style={{ position:'absolute', inset:0, width:'100%', height:'100%' }}>
              <circle cx="200" cy="100" r="60" fill="none" stroke="#FF6B00" strokeWidth="0.5" strokeDasharray="2 4"/>
              <circle cx="200" cy="100" r="30" fill="none" stroke="#FF6B00" strokeWidth="0.5" strokeDasharray="2 4"/>
              <line x1="200" y1="0" x2="200" y2="200" stroke="#FF6B00" strokeWidth="0.5" strokeDasharray="3 3"/>
              <line x1="0" y1="100" x2="400" y2="100" stroke="#FF6B00" strokeWidth="0.5" strokeDasharray="3 3"/>
              <polygon points="200,100 196,108 204,108" fill="#FF2020"/>
              <text x="206" y="98" fontFamily="Share Tech Mono" fontSize="8" fill="#FF2020">ANGEL-14</text>
              <polygon points="80,160 76,168 84,168" fill="#6BFF3B"/>
              <text x="86" y="158" fontFamily="Share Tech Mono" fontSize="8" fill="#6BFF3B">EVA-01</text>
              <line x1="80" y1="160" x2="200" y2="100" stroke="#FFB800" strokeWidth="0.5" strokeDasharray="1 3"/>
            </svg>
            <div style={{
              position:'absolute', top:8, right:10,
              fontFamily:"'Share Tech Mono',monospace", fontSize:9, color:'#FF6B00', letterSpacing:'.15em',
            }}>RNG 014.7KM · BR 045°</div>
          </div>

          <div style={{ height:1, margin:'18px 0', background:'repeating-linear-gradient(90deg,#FF6B00 0,#FF6B00 4px,transparent 4px,transparent 8px)', opacity:.3 }}/>

          <MicroLabel>[ INPUT · OPERATOR DIRECTIVE ]</MicroLabel>
          <div style={{ display:'grid', gridTemplateColumns:'1fr 1fr', gap:12, marginTop:10 }}>
            <TextInput label="OPERATOR ID" value="IKARI-S-003" onChange={()=>{}}/>
            <TextInput label="DIRECTIVE CODE" placeholder="ENTER CODE" onChange={()=>{}}/>
          </div>
        </div>

        {/* action panel */}
        <div style={{
          background:'#111', border:'1px solid #3D1500',
          clipPath:'polygon(0 0, calc(100% - 12px) 0, 100% 12px, 100% 100%, 0 100%)',
          padding:18, display:'flex', flexDirection:'column', gap:12,
        }}>
          <MicroLabel>[ AVAILABLE ACTIONS ]</MicroLabel>
          <Button variant="primary" size="lg">ENGAGE TARGET</Button>
          <Button variant="secondary" size="lg" icon={<Icon name="signal" size={14} color="#FF6B00"/>}>OPEN COMMS</Button>
          <Button variant="secondary" size="lg" icon={<Icon name="terminal" size={14} color="#FF6B00"/>}>RUN DIAGNOSTICS</Button>
          <Button variant="danger" size="lg">ABORT MISSION</Button>
          <div style={{ height:1, background:'#3D1500', margin:'4px 0' }}/>
          <MicroLabel>[ IRREVERSIBLE ]</MicroLabel>
          <HazardButton onClick={() => setShowModal(true)}>⚠ &nbsp;PURGE CORE</HazardButton>
          <div style={{ flex:1 }}/>
          <Button variant="ghost" size="sm" onClick={goDashboard}>← BACK TO OVERVIEW</Button>
        </div>
      </div>

      {/* Modal */}
      {showModal && (
        <div style={{
          position:'fixed', inset:0, background:'rgba(0,0,0,.85)',
          display:'flex', alignItems:'center', justifyContent:'center', zIndex:99,
          backgroundImage:'repeating-linear-gradient(0deg, rgba(255,255,255,.01) 0, rgba(255,255,255,.01) 1px, transparent 1px, transparent 3px)',
        }}>
          <div style={{
            background:'#0A0A0A', border:'2px solid #FF2020',
            boxShadow:'0 0 24px rgba(255,32,32,.5), 0 4px 30px rgba(0,0,0,.9)',
            clipPath:'polygon(0 0, calc(100% - 14px) 0, 100% 14px, 100% 100%, 14px 100%, 0 calc(100% - 14px))',
            width: 520, animation:'pip-pulse 2s ease-in-out infinite',
          }}>
            <div style={{ padding:'14px 18px', background:'rgba(255,32,32,.1)', borderBottom:'1px solid #3D1500', display:'flex', gap:12, alignItems:'center' }}>
              <Icon name="triangle-alert" size={22} color="#FF2020"/>
              <span style={{ fontFamily:"'Bebas Neue',sans-serif", color:'#FF2020', fontSize:24, letterSpacing:'.18em' }}>CONFIRM IRREVERSIBLE ACTION</span>
            </div>
            <div style={{ padding:18, color:'#fff', fontFamily:"'Rajdhani',sans-serif", fontSize:14, letterSpacing:'.04em', lineHeight:1.55 }}>
              <p>You are about to <code style={{color:'#FF2020', fontFamily:"'Share Tech Mono'"}}>PURGE</code> the auxiliary core. This action <b style={{color:'#FF2020'}}>cannot be undone</b> and will void all telemetry from CHN-14B.</p>
              <div style={{ paddingTop:8 }}>
                <MicroLabel color="#CC4400">[ TYPE "PURGE" TO PROCEED ]</MicroLabel>
                <input value={confirm} onChange={e=>setConfirm(e.target.value)} placeholder="________"
                  style={{
                    background:'#111', border:0, borderBottom:'2px solid #FF2020',
                    color:'#fff', fontFamily:"'Share Tech Mono',monospace", fontSize:14,
                    padding:'8px 10px', width:160, letterSpacing:'.1em', outline:'none', marginTop:6,
                  }}/>
              </div>
            </div>
            <div style={{ padding:'14px 18px', borderTop:'1px solid #3D1500', display:'flex', gap:10, justifyContent:'flex-end' }}>
              <Button variant="secondary" onClick={()=>{ setShowModal(false); setConfirm(''); }}>CANCEL</Button>
              <button disabled={confirm !== 'PURGE'} onClick={()=>{ alert('PURGE EXECUTED'); setShowModal(false); setConfirm(''); }}
                style={{
                  background: confirm === 'PURGE' ? 'repeating-linear-gradient(45deg,#FFB800 0,#FFB800 8px,#1A1A00 8px,#1A1A00 16px)' : '#1A0800',
                  padding:0, height:36, border:0, cursor: confirm === 'PURGE' ? 'pointer' : 'not-allowed',
                  opacity: confirm === 'PURGE' ? 1 : .5,
                  clipPath:'polygon(0 0, calc(100% - 10px) 0, 100% 10px, 100% 100%, 0 100%)',
                }}>
                <span style={{
                  display:'inline-flex', alignItems:'center', height:'100%', padding:'0 16px',
                  background:'rgba(0,0,0,.7)', color:'#fff',
                  fontFamily:"'Rajdhani',sans-serif", fontWeight:700,
                  letterSpacing:'.12em', textTransform:'uppercase', fontSize:13,
                }}>⚠ EXECUTE PURGE</span>
              </button>
            </div>
          </div>
        </div>
      )}
    </main>
  );
};
window.DetailView = DetailView;
