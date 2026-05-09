/* global React */
const App = () => {
  const [view, setView] = React.useState('dashboard');
  return (
    <div className="app-shell">
      <TopBar />
      <div className="app-body">
        <Sidebar activeId={view} onNavigate={setView} />
        {view === 'detail' || view === 'target'
          ? <DetailView goDashboard={() => setView('dashboard')} />
          : <Dashboard goDetail={() => setView('detail')} />}
        <RightRail />
      </div>
    </div>
  );
};
window.App = App;
