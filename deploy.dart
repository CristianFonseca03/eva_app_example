import 'dart:io';

void main(List<String> args) async {
  final mode = _parseMode(args);
  final action = _parseAction(args);

  print('EVA-01 deploy — action: $action, mode: $mode');

  final repo = await _gh(['repo', 'view', '--json', 'nameWithOwner', '-q', '.nameWithOwner']);
  final repoName = repo.split('/').last;
  final baseHref = '/$repoName/';

  if (action == 'build' || action == 'deploy') {
    await _build(mode, baseHref);
  }

  if (action == 'deploy') {
    await _deploy(repo, repoName);
  }
}

String _parseMode(List<String> args) {
  if (args.contains('--profile')) return 'profile';
  if (args.contains('--debug')) return 'debug';
  return 'debug';
}

String _parseAction(List<String> args) {
  if (args.contains('build')) return 'build';
  if (args.contains('deploy')) return 'deploy';
  _usage();
  exit(1);
}

void _usage() {
  print('''
Uso: dart deploy.dart <acción> [opciones]

Acciones:
  build    Compilar para web
  deploy   Compilar y desplegar en GitHub Pages

Opciones:
  --debug    Modo debug (por defecto)
  --profile  Modo profile (optimizado, con DevTools)

Ejemplos:
  dart deploy.dart build
  dart deploy.dart deploy --profile
  dart deploy.dart build --debug
''');
}

Future<void> _build(String mode, String baseHref) async {
  print('→ build web [$mode] (base-href: $baseHref)');
  final buildArgs = ['flutter', 'build', 'web', '--base-href', baseHref];
  if (mode == 'profile') buildArgs.add('--profile');
  if (mode == 'debug') buildArgs.add('--debug');
  await _run('fvm', buildArgs);
}

Future<void> _deploy(String repo, String repoName) async {
  const tmpDir = '/tmp/gh-pages-deploy';
  print('→ deploy a gh-pages');

  final worktreeResult = await Process.run(
    'git', ['worktree', 'add', tmpDir, 'gh-pages'],
    runInShell: true,
  );
  if (worktreeResult.exitCode != 0) {
    await Process.run('git', ['branch', '-D', 'gh-pages'], runInShell: true);
    await _run('git', ['worktree', 'add', '--orphan', '-B', 'gh-pages', tmpDir]);
  }

  await _run('cp', ['-r', 'build/web/.', tmpDir]);

  final now = DateTime.now();
  final timestamp = '${now.year}-${_pad(now.month)}-${_pad(now.day)} ${_pad(now.hour)}:${_pad(now.minute)}';

  await _run('git', ['-C', tmpDir, 'add', '-A']);
  await _run('git', ['-C', tmpDir, 'commit', '-m', 'deploy: $timestamp']);
  await _run('git', ['-C', tmpDir, 'push', 'origin', 'gh-pages', '--force']);
  await _run('git', ['worktree', 'remove', tmpDir, '--force']);

  final owner = repo.split('/').first.toLowerCase();
  print('✓ https://$owner.github.io/$repoName/');
}

String _pad(int n) => n.toString().padLeft(2, '0');

Future<String> _gh(List<String> args) async {
  final result = await Process.run('gh', args, runInShell: true);
  if (result.exitCode != 0) {
    stderr.writeln('gh error: ${result.stderr}');
    exit(result.exitCode);
  }
  return (result.stdout as String).trim();
}

Future<void> _run(String cmd, List<String> args) async {
  final proc = await Process.start(cmd, args, runInShell: true);
  proc.stdout.pipe(stdout);
  proc.stderr.pipe(stderr);
  final code = await proc.exitCode;
  if (code != 0) {
    stderr.writeln('Error: $cmd ${args.join(' ')} (exit $code)');
    exit(code);
  }
}
