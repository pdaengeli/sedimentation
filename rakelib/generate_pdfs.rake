# frozen_string_literal: true

# Generate bookmarked PDFs using pagedjs-cli.
#
# Prerequisites:
#   npm install -g pagedjs-cli
#   bundle exec jekyll serve   (must be running before invoking this task)
#
# Usage:
#   rake generate_pdfs
#   rake generate_pdfs BASE_URL=http://localhost:4000/sedimentation
#
# Output: objects/pdfs/  (one PDF per tributary + one full-book PDF)
#
# Note: Browser "Save as PDF" does not support PDF bookmarks. This task uses
# pagedjs-cli's --outline-tags option to produce a fully bookmarked PDF
# suitable for archival and accessibility compliance.

desc 'Generate bookmarked PDFs via pagedjs-cli (requires: npm install -g pagedjs-cli, jekyll serve)'
task :generate_pdfs do
  base = ENV.fetch('BASE_URL', 'http://localhost:4000/sedimentation')
  out  = 'objects/pdfs'
  FileUtils.mkdir_p(out)

  tributaries = %w[atmosphere biota humans land water]

  tributaries.each do |slug|
    target = "#{out}/#{slug}.pdf"
    puts "Generating #{target}..."
    sh "pagedjs-cli #{base}/print/#{slug}/ -o #{target} --outline-tags h1,h2,h3"
  end

  book_target = "#{out}/sedimentation-book.pdf"
  puts "Generating #{book_target}..."
  sh "pagedjs-cli #{base}/print/book/ -o #{book_target} --outline-tags h1,h2,h3"

  puts "\nPDFs written to #{out}/"
end
