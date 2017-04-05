# config variables
property channelName : "[Paste Channel Name Here]"
property webhookURL : "[Paste Webhook URL Here]"
property userName : "[Your Slack Username Here]"
property emojiName : "musical_note"

on replace_chars(this_text, search_string, replacement_string)
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to ""
	return this_text
end replace_chars

# content
if application "Spotify" is running then
	using terms from application "Spotify"
		tell application "Spotify"
			if player state is playing then
				set currentArtist to artist of current track as string
				set currentTrack to name of current track as string
				set currentID to id of current track as string

				set theArtist to my replace_chars(current track's artist, "\"", "\\\"")
				set theName to currentTrack
				set trackLink to "https://open.spotify.com/track/" & my replace_chars(currentID, "spotify:track:", "")
				set trackString to theName & " - " & theArtist & ""

				do shell script "curl -X POST --data-urlencode 'payload={\"channel\": \"" & channelName & "\", \"username\": \"" & userName & "\", \"text\": \"" & my replace_chars(trackString, "'", "\\u0027") & " - " & trackLink & "\", \"icon_emoji\": \":" & emojiName & ":\"}' " & webhookURL

			end if
		end tell
	end using terms from
end if
return 5
