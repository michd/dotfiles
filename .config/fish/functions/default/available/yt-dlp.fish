function yt-dlp-mp3 --description 'download an mp3 from a youtube video'
    yt-dlp -x --audio-format mp3 --audio-quality 0 $argv --verbose
end

function yt-dlp-subs --description 'download video with embedded subtitles'
    yt-dlp --write-auto-sub --sub-lang "en.*" --embed-subs $argv
end

function ffmpeg-to-mp4 --description 'convert a video to h.264 mp4 preserving subtitles'
    ffmpeg -i $argv -vcodec libx264 -c copy -c:s mov_text $argv.mp4
end
