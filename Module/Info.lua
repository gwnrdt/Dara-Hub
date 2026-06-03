return function(Tabs)
do
    InviteCode = "ny6pJgnR6c"
    DiscordAPI = "https://discord.com/api/v10/invites/" .. InviteCode .. "?with_counts=true&with_expiration=true"

    success, Response = pcall(function()
        return game:GetService("HttpService"):JSONDecode(request({
            Url = DiscordAPI,
            Method = "GET"
        }).Body)
    end)
    
    if success and Response and Response.guild then
        Tabs.info:Section({
            Title = "Join My Discord Server",
            TextSize = 20,
        })

        -- Formatting member counts for the description
        local totalMembers = Response.approximate_member_count or 0
        local onlineMembers = Response.approximate_presence_count or 0
        local memberStatus = string.format("\n\n👥 Total Members: %s\n🟢 Online: %s", tostring(totalMembers), tostring(onlineMembers))

        DiscordServerParagraph = Tabs.info:Paragraph({
            Title = tostring(Response.guild.name),
            Flag = "DiscordServerParagraph",
            Desc = (Response.guild.description or "No description available.") .. memberStatus,
            Image = "https://cdn.discordapp.com/icons/" .. Response.guild.id .. "/" .. Response.guild.icon .. ".png?size=1024",
            ImageSize = 48,
            Buttons = {
                {
                    Title = "Copy link",
                    Icon = "link",
                    Callback = function()
                        setclipboard("https://discord.gg/" .. InviteCode)
                    end
                }
            }
        })
    end
end    
    Tabs.info:Section({
        Title = "TikTok"
    })

    Tabs.info:Paragraph({
        Title = "Follow my main don't follow my shit pnsdgayahh account",
        Desc = "@pnsdg",
        Image = "https://linkspreview.netlify.app/fetchimage/https%3A%2F%2Fwww.tiktok.com%2F%40pnsdg",
        ImageSize = 48,
        Buttons = {
            {
                Title = "Copy Link",
                Icon = "music-2",
                Callback = function()
                    setclipboard("https://www.tiktok.com/@pnsdg")
                end
            }
        }
    })
    
    Tabs.info:Paragraph({
        Title = "My dummy account",
        Desc = "@pnsdgayahh",
        Image = "https://linkspreview.netlify.app/fetchimage/https%3A%2F%2Fwww.tiktok.com%2F%40pnsdgayahh",
        ImageSize = 48,
        Buttons = {
            {
                Title = "Copy Link",
                Icon = "music-2",
                Callback = function()
                    setclipboard("https://www.tiktok.com/@pnsdg")
                end
            }
        }
    })
    
    Tabs.info:Section({
        Title = "YouTube"
    })

    Tabs.info:Paragraph({
        Title = "Subscribe to my main account of you like Minecraft content",
        Desc = "@pnsdg",
        Image = "https://linkspreview.netlify.app/fetchimage/https%3A%2F%2FYouTube.com%2F%40pnsdg",
        ImageSize = 48,
        Buttons = {
            {
                Title = "Copy Link",
                Icon = "youtube",
                Callback = function()
                    setclipboard("https://m.youtube.com/@pnsdg")
                end
            }
        }
    })

    Tabs.info:Paragraph({
        Title = "Lol I Left this gta account for months",
        Desc = "@PnsdgSa",
        Image = "https://linkspreview.netlify.app/fetchimage/https%3A%2F%2FYouTube.com%2F%40pnsdgsa",
        ImageSize = 48,
        Buttons = {
            {
                Title = "Copy Link",
                Icon = "youtube",
                Callback = function()
                    setclipboard("https://www.youtube.com/@PnsdgSa")
                end
            }
        }
    })

    Tabs.info:Paragraph({
        Title = "IDK what should post on this one",
        Desc = "@BadpiggyTechTutorial",
        Image = "https://linkspreview.netlify.app/fetchimage/https%3A%2F%2FYouTube.com%2F%40BadpiggyTechTutorial",
        ImageSize = 48,
        Buttons = {
            {
                Title = "Copy Link",
                Icon = "youtube",
                Callback = function()
                    setclipboard("https://www.youtube.com/@BadpiggyTechTutorial")
                end
            }
        }
    })
end
