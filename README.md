Glyphish Gallery
================

Browse and search through your [Glyphish icons](http://glyphish.com/) in style.

![Screenshot](screenshots/screenshot_1.png)

## Features

* Filter between PNG or SVG images*.
![Screenshot](screenshots/screenshot_3.png)
* Search through every icon, by name or tags.
![Screenshot](screenshots/screenshot_4.png)
* Drag and drop icons right into Xcode.
![Screenshot](screenshots/screenshot_2.png)
* Import your own metadata in a JSON file.
![](screenshots/import_view.png)

<i>*SVG icons included in the .zip with the 5/13/2014 update.</i>

## Changing the Glyphish Folder
To change the location of your Glyphish folder (if it has been moved), or to update it, navigate to "Glyphish Gallery" and then "Preferences...".

![](https://i.imgur.com/qrbIxR5.png)

Or, you can use the shortcut `⌘.`.

You will then get this preferences window:

![](https://i.imgur.com/NLj4EE6.png)

On clicking "Pick", a popup file browser will then let you select the folder which you would like to use.  The gallery will then reload with the contents of the new folder.

## Creating Metadata
To contribute keywords to the metadata set (help is always appreciated!), head to the [metadata](https://github.com/glyphish/metadata) repository, which is a publicaly-editable spreadsheet. Add keywords in columns for each icon.

To create your own personal metadata, follow these simple steps:

1. Create a new JSON file, such as `custom.json`.
2. Open the JSON file in your favorite editor.
3. Create an associative array, and use the icon name(s) as the key(s) (without the extension).

```json
{
  "01-refresh":[
  ],
  "02-redo":[
  ],
  // etc.
}
```

<p>4. Add the tags (in quotes) in the value (array) part of the JSON.</p>

```json
{
  "01-refresh":[
    "again",
    "reload",
    "circular arrow",
    // etc.
  ],
  "02-redo":[
    "try again",
    "refresh",
    "circular arrow",
    // etc.
  ],
  // etc.
}
```
<p>5. Go to <a href='http://pro.jsonlint.com/'>JSONLint</a> and make sure that your metadata is valid JSON (or else Glyphish Gallery will NOT be able to process it!).
<p>6. If it passes inspection, save the file and <a href='#importing-metadata'>import the metadata</a>.</p>

## Importing Metadata

To import your own metadata .JSON file, you must first make sure that you have the correct [metadata format](#creating metadata).

After you have inserted all of your metadata, and saved the .JSON file in an easily accessible location, navigate to "Metadata" and then "Import".

![](screenshots/metadata_import.png)

Or use the shortcut `⌘I`.

You'll then see this window:

![](screenshots/import_view.png)

From here, drag and drop your .JSON file onto the dropzone.  The file will then be added!

## Deleting Imported Metadata
To import your imported metadata, navigate to "Metadata" and then "Manage"

![](screenshots/metadata_import.png)

Or use the shortcut `⇧⌘M`.

You'll then see this window:

![](screenshots/manage_view.png)

Select a JSON file, and press your delete key to remove it.

Because these files are stored locally, you will need to import them onto different computers, if you use Glyphish on different machines.  In the future, it is possible that they're will be an option to choose a folder for your Glyphish metadata files, and you could create a folder in Dropbox, and keep them synced.

## Support
To resolve any issues you may be having, [open an issue](https://github.com/glyphish/gallery/issues).  Any issues opened will be at least responded to within **24 hours**, and resolved as soon as possible!

## Changelog
#### Version 1.0
- Original project.
- Browse Glyphish icons, and search by icon name.

#### Version 2.0
- Filter between SVG and PNG images.
- Search by icon name or tags.
- Import and Manage custom metadata to enhance searches.

## Contributors

#### Version 1.0
Developed by [Jörgen Isaksson](https://github.com/jorgenisaksson).  Check out Jörgen's work at Bitfield in the [Mac App Store](http://appstore.com/mac/bitfieldab).

#### Version 2.0
Developed by [Rudd Fawcett](http://ruddfawcett.com). You can find all of his open source projects on [GitHub](https://github.com/ruddfawcett).

Contributions to search and project structure by [Alec Gorge](http://alecgorge.com) ([GitHub](//github.com/alecgorge)).

#### Glyphish Creator
Designed by [Joseph Wain](https://twitter.com/jpwain).  Visit Joseph's [personal site](http://www.penandthink.com), or peruse his [dribbble](https://dribbble.com/jpwain).

## Contributing
<p>1. Fork gallery to `username/gallery`. <br/>
2. Clone the project:</p>

```
$ git clone https://github.com/{username}/gallery
```

<p>3. Create your feature branch:</p>

````
$ git checkout -b my-new-feature
```

<p>4. Code your awesome feature idea. <br/>
5. Commit your changes:</p>

```
$ git commit -am 'Add some feature'
```

<p>6. Push to the branch:</p>

```
$ git push origin my-new-feature
```

<p>7. Create a new Pull Request to the `development` branch.</p>

If everything checks out, and we like your pull request, we'll merge it to `development`.  After merging some other branches to development (besides yours), we'll merge all of the new features to master, where they'll be part of the new release!

## Questions?

- Open an issue.

## Connect
- Follow [@Glyphish on Twitter](https://twitter.com/glyphish).
- Signup for [Glyphish news](https://confirmsubscription.com/h/r/7C4D8263FEF6DC79).
- Directly [contact Glyphish](https://helloglyphish.wufoo.com/forms/send-a-message-about-glyphish-icons/).
- Browse [available icon sets](http://www.glyphish.com).
