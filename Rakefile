# frozen_string_literal: true

desc 'Unit testing...'
task :test do
  Dir.chdir('lua') do
    Rake::FileList["**/test_*.lua"].each do |test|
      sh("lua #{test} -v", verbose: false) do |success, _|
        exit 1 unless success
      end
    end
  end
end

task default: [:test]
