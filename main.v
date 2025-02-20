import vweb
import os

struct App {
	vweb.Context
}

fn main() {
	vweb.run[App](&App{}, 8080)
}

@['/']
pub fn (mut app App) index() vweb.Result {
	html_path := os.join_path(os.dir(@FILE), 'static', 'index.html')
	html_content := os.read_file(html_path) or {
		return app.text('Fehler beim Laden der HTML-Datei.')
	}
	return app.html(html_content)
}

@['/api/message']
pub fn (mut app App) message() vweb.Result {
	return app.text('Hallo von V Backend!')
}

@['/public/:path']
pub fn (mut app App) public_files(path string) vweb.Result {
	file_path := os.join_path(os.dir(@FILE), 'public', path)
	if !os.exists(file_path) {
		return app.not_found()
	}
	file_content := os.read_file(file_path) or { return app.text('Fehler beim Laden der Datei.') }
	return app.ok(file_content)
}
