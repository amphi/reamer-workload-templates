use std::{env, fs, path::PathBuf, process};

fn main() {
    let results_dir = match env::var("RESULTS_DIR") {
        Ok(dir) if !dir.is_empty() => PathBuf::from(dir),
        _ => {
            eprintln!("RESULTS_DIR is not set");
            process::exit(1);
        }
    };

    if let Err(err) = fs::create_dir_all(&results_dir) {
        eprintln!("failed to create RESULTS_DIR {}: {err}", results_dir.display());
        process::exit(1);
    }

    let output_path = results_dir.join("test-output.json");
    let json = r#"{"status":"ok","message":"test output"}"#;

    if let Err(err) = fs::write(&output_path, json) {
        eprintln!("failed to write {}: {err}", output_path.display());
        process::exit(1);
    }

    println!("{}", output_path.display());
}
