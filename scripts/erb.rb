require 'erb'
require 'yaml'

def generate_badge array
    badge = ""
    array.each { |t|
        case t
        when 'linux'
            badge = badge + "![linux](/images/linux.png)"
        when 'windows'
            badge = badge + "![windows](/images/windows.png)"
        when 'macos'
            badge = badge + "![macos](/images/apple.png)"
        when 'firefox'
            badge = badge + "![firefox](/images/firefox.png)"
        when 'safari'
            badge = badge + "![safari](/images/safari.png)"
        when 'chrome'
            badge = badge + "![chrome](/images/chrome.png)"
        when 'burpsuite'
            badge = badge + "![burp](/images/burp.png)"
        when 'caido'
            badge = badge + "![caido](/images/caido.png)"
        when 'zap'
            badge = badge + "![zap](/images/zap.png)"
        end
    }
    return badge
end

def generate_tags array
    tags = ""
    array.each { |t|
        tags = tags + "`#{t}` "
    }
    return tags
end

categorize_template_tags = %q{
## Tools for <%= @ct_tag %>

<%= @ct_head %>
<%= @ct_data %>

}.gsub(/^  /, '')

categorize_template_langs = %q{
## Tools Made of <%= @ct_lang %>

<%= @ct_head %>
<%= @ct_data %>

}.gsub(/^  /, '')

template = %q{
<h1 align="center">
  <br>
  <a href="https://github.com/hahwul/MobileHackersWeapons"><img src="images/mhw.jpg" alt="MobileHackersWeapons Logo"></a>
  <br>
  <img src="https://img.shields.io/github/languages/top/hahwul/MobileHackersWeapons?style=flat">
  <img src="https://img.shields.io/github/last-commit/hahwul/MobileHackersWeapons?style=flat">
  <img src="https://img.shields.io/badge/PRs-welcome-cyan">
  <img src="https://github.com/hahwul/MobileHackersWeapons/workflows/Build/badge.svg">
  <img src="https://github.com/hahwul/MobileHackersWeapons/workflows/CodeQL/badge.svg">
  <a href="https://twitter.com/intent/follow?screen_name=hahwul"><img src="https://img.shields.io/twitter/follow/hahwul?style=flat&logo=twitter"></a>
</h1>
A collection of cool tools used by Mobile hackers. Happy hacking , Happy bug-hunting

## Family project
[![WebHackersWeapons](https://img.shields.io/github/stars/hahwul/WebHackersWeapons?label=WebHackersWeapons)](https://github.com/hahwul/WebHackersWeapons)
[![MobileHackersWeapons](https://img.shields.io/github/stars/hahwul/MobileHackersWeapons?label=MobileHackersWeapons)](https://github.com/hahwul/MobileHackersWeapons)

## Table of Contents
- [Weapons](#weapons)
- [Contribute](/CONTRIBUTING.md)
- [Thanks to contributor](#thanks-to-contributor)

## Weapons
*Attributes*
|       | Attributes                                        |
|-------|---------------------------------------------------|
| Types | `Analysis` `Pentest` `Proxy` `RE` `Scripts` `Scanner` `Utils` `Device` `Discovery`, `Monitor`, `NFC`, `Target`, `Bluetooth`, `Jailbreak`, `Inject`, `Unpinning`|
| Tags  | <%= tags.uniq.join ' ' %>                         |
| Langs | <%= langs.uniq.join ' ' %>                        |

### All
<%= all_tools %>

### iOS
<%= ios_tools %>

### Android
<%= android_tools %>

## Thanks to (Contributor)
WHW's open-source project and made it with ❤️ if you want contribute this project, please see [CONTRIBUTING.md](https://github.com/hahwul/MobileHackersWeapons/blob/main/CONTRIBUTING.md) and Pull-Request with cool your contents.

[![](/images/CONTRIBUTORS.svg)](https://github.com/hahwul/MobileHackersWeapons/graphs/contributors)

}.gsub(/^  /, '')

tags = []
langs = []
categorize_tags = {}
categorize_langs = {}
head = "| Type | Name | Description | Star |\n"
head = head + "| --- | --- | --- | --- |"
all_tools = head + "\n"
ios_tools = head + "\n"
android_tools = head + "\n"

weapons = []
weapons_obj = {
    "analysis" => [],
    "pentest" => [],
    "proxy" => [],
    "re" => [],
    "scripts" => [],
    "scanner" => [],
    "utils" => [],
    "device" => [],
    "discovery" => [],
    "monitor" => [],
    "nfc" => [],
    "target" => [],
    "bluetooth" => [],
    "Jailbreak" => [],
    "inject" => [],
    "unpinning" => [],
    "etc" => []
}

Dir.entries("./weapons/").each do | name |
    if name != '.' && name != '..'
        begin
            data = YAML.load(File.open("./weapons/#{name}"))

            if data['type'] != "" && data['type'] != nil
                type_key = data['type'].downcase
                if weapons_obj[type_key] != nil
                    weapons_obj[type_key].push data
                else
                    weapons_obj[type_key] = []
                    weapons_obj[type_key].push data
                end
            else
                weapons_obj['etc'].push data
            end
        rescue => e
            puts e
        end
    end
end

weapons_obj.each do |key,value|
    weapons.concat value
end

weapons.each do | data |
    begin
        name = data['name']
        temp_tags = []
        begin
          data['tags'].each do |t|
             temp_tags.push "[`#{t}`](/categorize/tags/#{t}.md)"
          end
          tags.concat temp_tags
        rescue
        end
        lang_badge = ""
        begin
          if data['lang'].length > 0 && data['lang'] != "null"
              langs.push "[`#{data['lang']}`](/categorize/langs/#{data['lang'].gsub('#','%23')}.md)"
              lang_badge = "[![#{data['lang']}](/images/#{data['lang'].downcase.gsub('#','%23')}.png)](/categorize/langs/#{data['lang'].gsub('#','%23')}.md)"
          end
        rescue
        end

        popularity = ""

        if data['url'].length > 0
            name = "[#{name}](#{data['url']})"
        end

        if data['url'].include? "github.com"
            split_result = data['url'].split "//github.com/"
            popularity = "![](https://img.shields.io/github/stars/#{split_result[1]}?label=%20)"
        end
        badge = generate_badge(data['platform'])
        line = "|#{data['type']}|#{name}|#{data['description']}|#{popularity}|"
        case data['category'].downcase
        when 'android'
            android_tools = android_tools + line + "\n"
        when 'ios'
            ios_tools = ios_tools + line + "\n"
        when 'all'
            all_tools = all_tools + line + "\n"
        else
            puts name
        end

        tmp_lang = data['lang']
        tmp_tags = data['tags']

        if tmp_tags != nil
            tmp_tags.each do |t|
                if categorize_tags[t] == nil
                    categorize_tags[t] = line + "\n"
                else
                    categorize_tags[t] = categorize_tags[t] + line + "\n"
                end
            end
        end

        if tmp_lang != nil
            if categorize_langs[tmp_lang] == nil
                categorize_langs[tmp_lang] = line + "\n"
            else
                categorize_langs[tmp_lang] = categorize_langs[tmp_lang] + line + "\n"
            end
        end

    rescue => e
        puts e
    end
end

markdown = ERB.new(template, trim_mode: "%<>")
#puts markdown.result
File.write './README.md', markdown.result

categorize_tags.each do |key,value|
    if key != nil && key != ""
        @ct_tag = key
        @ct_head = head + "\n"
        @ct_data = value
        tag_markdown = ERB.new(categorize_template_tags, trim_mode: "%<>")
        File.write "./categorize/tags/#{@ct_tag}.md", tag_markdown.result
    end
end

categorize_langs.each do |key,value|
    if key != nil && key != ""
        @ct_lang = key
        @ct_head = head + "\n"
        @ct_data = value
        lang_markdown = ERB.new(categorize_template_langs, trim_mode: "%<>")
        File.write "./categorize/langs/#{@ct_lang}.md", lang_markdown.result
    end
end
