/* global React */
const { useState, useEffect, useRef } = React;

// ============================================================
// Buttons
// ============================================================
const Button = ({ variant = 'secondary', size = 'md', icon, children, ...rest }) => {
  const baseStyles = {
    fontFamily: "'Rajdhani', sans-serif",
    textTransform: 'uppercase',
    letterSpacing: '0.12em',
    fontWeight: 700,
    border: 0,
    cursor: 'pointer',
    display: 'inline-flex',
    alignItems: 'center',
    gap: 8,
    transition: 'all 150ms ease',
    clipPath: 'polygon(0 0, calc(100% - 10px) 0, 100% 10px, 100% 100%, 0 100%)',
  };
  const sizes = {
    sm: { height: 28, padding: '6px 12px', fontSize: 11 },
    md: { height: 36, padding: '10px 16px', fontSize: 13 },
    lg: { height: 44, padding: '12px 24px', fontSize: 15 },
  };
  const variants = {
    primary: {
      background: '#FF2020', color: '#fff',
      boxShadow: '0 0 8px rgba(255,32,32,.6), 0 0 20px rgba(255,32,32,.3)',
    },
    secondary: {
      background: 'transparent', color: '#FF6B00', border: '1px solid #FF6B00',
    },
    danger: {
      background: '#000', color: '#FF2020', border: '1px solid #FF2020',
      boxShadow: 'inset 0 0 0 1px #FF2020, inset 0 0 6px rgba(255,32,32,.3)',
    },
    ghost: {
      background: 'transparent', color: '#666', border: '1px solid #3D1500',
    },
  };
  return (
    <button style={{...baseStyles, ...sizes[size], ...variants[variant]}} {...rest}>
      {icon}{children}
    </button>
  );
};

const HazardButton = ({ children, ...rest }) => (
  <button style={{
    background: 'repeating-linear-gradient(45deg,#FFB800 0,#FFB800 8px,#1A1A00 8px,#1A1A00 16px)',
    padding: 0, height: 36, border: 0, cursor: 'pointer',
    clipPath: 'polygon(0 0, calc(100% - 10px) 0, 100% 10px, 100% 100%, 0 100%)',
  }} {...rest}>
    <span style={{
      display: 'inline-flex', alignItems: 'center', height: '100%', padding: '0 16px',
      background: 'rgba(0,0,0,.7)', color: '#fff',
      fontFamily: "'Rajdhani', sans-serif", fontWeight: 700,
      letterSpacing: '0.12em', textTransform: 'uppercase', fontSize: 13,
    }}>{children}</span>
  </button>
);

// ============================================================
// Labels
// ============================================================
const MicroLabel = ({ children, color = '#666', ...rest }) => (
  <span style={{
    fontFamily: "'Share Tech Mono', monospace",
    fontSize: 9, letterSpacing: '0.18em',
    textTransform: 'uppercase', color,
  }} {...rest}>{children}</span>
);

const Pip = ({ status = 'active', pulse = false }) => {
  const colors = { active: '#6BFF3B', standby: '#FFB800', danger: '#FF2020', offline: '#555' };
  return (
    <span style={{
      width: 8, height: 8, display: 'inline-block', flexShrink: 0,
      background: colors[status],
      boxShadow: status === 'offline' ? 'none' : `0 0 6px ${colors[status]}`,
      animation: pulse ? 'pip-pulse 1.5s ease-in-out infinite' : 'none',
    }}/>
  );
};

const StatusBadge = ({ status = 'active', children }) => {
  const colors = {
    active: '#6BFF3B', standby: '#FFB800',
    danger: '#FF2020', offline: '#888', synced: '#F5C518', warning: '#FF6B00',
  };
  const c = colors[status] || '#FF6B00';
  return (
    <span style={{
      display: 'inline-flex', alignItems: 'center', gap: 6,
      fontFamily: "'Share Tech Mono', monospace", fontSize: 10,
      letterSpacing: '0.18em', textTransform: 'uppercase',
      padding: '4px 10px', height: 22,
      background: status === 'offline' ? '#1a1a1a' : `rgba(${hexToRgb(c)},.12)`,
      color: c, border: `1px solid ${c}`,
      clipPath: 'polygon(0 0, calc(100% - 6px) 0, 100% 6px, 100% 100%, 0 100%)',
      animation: status === 'danger' ? 'pip-pulse 1.5s ease-in-out infinite' : 'none',
    }}>
      <Pip status={status === 'synced' ? 'standby' : status === 'warning' ? 'standby' : status} />
      {children || status.toUpperCase()}
    </span>
  );
};
function hexToRgb(h) {
  h = h.replace('#','');
  const r = parseInt(h.slice(0,2),16), g = parseInt(h.slice(2,4),16), b = parseInt(h.slice(4,6),16);
  return `${r},${g},${b}`;
}

// ============================================================
// Inputs
// ============================================================
const TextInput = ({ label, error, value, onChange, placeholder, ...rest }) => {
  const [focus, setFocus] = useState(false);
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 4 }}>
      {label && <MicroLabel color="#CC4400">[ {label} ]</MicroLabel>}
      <input
        value={value} onChange={onChange} placeholder={placeholder}
        onFocus={() => setFocus(true)} onBlur={() => setFocus(false)}
        style={{
          background: '#111', color: '#FF6B00',
          fontFamily: "'Share Tech Mono', monospace", fontSize: 13,
          padding: '10px 12px', border: 0,
          borderBottom: `2px solid ${error ? '#FF2020' : '#FF6B00'}`,
          borderLeft: `3px solid ${error || focus ? (error ? '#FF2020' : '#FF2020') : 'transparent'}`,
          outline: 'none', letterSpacing: '0.06em',
          boxShadow: error ? '0 0 8px rgba(255,32,32,.4)' : focus ? '0 0 8px rgba(255,107,0,.3)' : 'none',
          animation: error ? 'err-pulse 1s ease-in-out infinite' : 'none',
        }} {...rest}
      />
      {error && <MicroLabel color="#FF2020">ERR · {error}</MicroLabel>}
    </div>
  );
};

// ============================================================
// Cards
// ============================================================
const DataCard = ({ category, label, value, unit, status = 'active', children }) => (
  <div style={{
    background: '#111', border: '1px solid #3D1500',
    borderTop: `2px solid ${status === 'danger' ? '#FF2020' : '#FF6B00'}`,
    clipPath: 'polygon(0 0, calc(100% - 12px) 0, 100% 12px, 100% 100%, 0 100%)',
    padding: '12px 14px', position: 'relative',
  }}>
    <MicroLabel>[ {category} ]</MicroLabel>
    <div style={{
      fontFamily: "'Rajdhani', sans-serif", textTransform: 'uppercase',
      letterSpacing: '.1em', fontSize: 11, color: '#CC4400', paddingTop: 6,
    }}>{label}</div>
    {value !== undefined && (
      <div style={{
        fontFamily: "'Share Tech Mono', monospace", fontSize: 28,
        color: status === 'danger' ? '#FF2020' : '#fff',
        paddingTop: 6, fontWeight: 700,
      }}>{value}{unit && <span style={{fontSize:18, color:'#FFB800'}}>{unit}</span>}</div>
    )}
    {children && (
      <>
        <div style={{
          height: 1, margin: '10px 0',
          background: 'repeating-linear-gradient(90deg,#FF6B00 0,#FF6B00 4px,transparent 4px,transparent 8px)',
          opacity: .3,
        }}/>
        {children}
      </>
    )}
  </div>
);

// ============================================================
// Progress
// ============================================================
const ProgressBar = ({ value = 0, label, level = 'normal', thin = false }) => {
  const fill = level === 'crit' ? '#FF2020' : level === 'haz' ? '' : level === 'sync' ? '#F5C518' : '#FF6B00';
  return (
    <div>
      {label && (
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
          <MicroLabel>[ {label} ]</MicroLabel>
          <span style={{
            fontFamily: "'Share Tech Mono', monospace", fontSize: 11,
            color: level === 'crit' ? '#FF2020' : '#fff',
          }}>{Math.round(value)}%</span>
        </div>
      )}
      <div style={{
        height: thin ? 4 : 8, background: '#1A0800',
        marginTop: 4, position: 'relative', overflow: 'hidden',
      }}>
        <div style={{
          height: '100%', width: `${value}%`,
          background: level === 'haz' ? 'repeating-linear-gradient(45deg,#FFB800 0,#FFB800 8px,#1A1A00 8px,#1A1A00 16px)' : fill,
          boxShadow: level === 'crit' ? '0 0 8px rgba(255,32,32,.6)' :
                     level === 'sync' ? '0 0 4px rgba(245,197,24,.5)' :
                     level === 'haz' ? 'none' :
                     '0 0 6px rgba(255,107,0,.5)',
          animation: level === 'crit' ? 'pip-pulse 1s ease-in-out infinite' : 'none',
        }}/>
      </div>
    </div>
  );
};

// ============================================================
// Alert
// ============================================================
const AlertPanel = ({ level = 'danger', code, children }) => {
  const c = level === 'danger' ? '#FF2020' : '#FF6B00';
  return (
    <div style={{
      display: 'flex', gap: 14, padding: '14px 16px', alignItems: 'flex-start',
      background: level === 'danger' ? 'rgba(255,32,32,.06)' : 'rgba(255,107,0,.06)',
      borderLeft: `4px solid ${c}`,
    }}>
      <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.5">
        <path d="M12 3 L22 21 H2 Z"/><path d="M12 10 V15"/><path d="M12 17 V18"/>
      </svg>
      <div>
        <div style={{
          fontFamily: "'Share Tech Mono', monospace", fontSize: 11,
          color: c, letterSpacing: '0.18em', textTransform: 'uppercase', paddingBottom: 4,
        }}>{code}</div>
        <div style={{
          fontFamily: "'Rajdhani', sans-serif", color: '#fff',
          fontSize: 14, letterSpacing: '0.04em', lineHeight: 1.5,
        }}>{children}</div>
      </div>
    </div>
  );
};

// ============================================================
// Icon
// ============================================================
const Icon = ({ name, size = 20, color }) => (
  <img src={`../../assets/icons/${name}.svg`} alt={name}
    style={{
      width: size, height: size,
      filter: color ? colorFilter(color) : 'none',
    }}/>
);
function colorFilter(c) {
  // crude: assume orange tone, recolor by mapping
  if (c === '#FF6B00') return 'brightness(0) saturate(100%) invert(48%) sepia(95%) saturate(2870%) hue-rotate(360deg) brightness(105%) contrast(105%)';
  if (c === '#FF2020') return 'brightness(0) saturate(100%) invert(28%) sepia(90%) saturate(7497%) hue-rotate(354deg) brightness(98%) contrast(108%)';
  if (c === '#fff' || c === '#FFFFFF') return 'brightness(0) invert(1)';
  if (c === '#666') return 'brightness(0) invert(0.4)';
  return 'none';
}

// ============================================================
// Keyframes (injected once)
// ============================================================
(() => {
  if (document.getElementById('eva-keyframes')) return;
  const s = document.createElement('style');
  s.id = 'eva-keyframes';
  s.textContent = `
    @keyframes pip-pulse { 0%,100%{opacity:1} 50%{opacity:.4} }
    @keyframes err-pulse { 0%,100%{box-shadow:0 0 8px rgba(255,32,32,.4)} 50%{box-shadow:0 0 16px rgba(255,32,32,.7)} }
    @keyframes scan { 0%{transform:translateY(-10%)} 100%{transform:translateY(110%)} }
    @keyframes flicker { 0%,100%{opacity:1} 41%,43%{opacity:.85} 92%{opacity:.92} }
    @keyframes data-flash { 0%{background:rgba(255,184,0,.6)} 100%{background:transparent} }
  `;
  document.head.appendChild(s);
})();

Object.assign(window, {
  Button, HazardButton, MicroLabel, Pip, StatusBadge,
  TextInput, DataCard, ProgressBar, AlertPanel, Icon,
});
