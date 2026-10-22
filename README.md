# d64quant

d64quant is a PNG palette quantizer for graphics with features for [Doom 64](https://www.doom64.com/). It is based on [pngquant](https://pngquant.org), a PNG compressor that significantly reduces file sizes by converting images to a more efficient 8-bit PNG format *with alpha channel* (often 60-80% smaller than 24/32-bit PNG files). Compressed images are fully standards-compliant and are supported by all web browsers and operating systems.

d64quant adds a configurable color for transparent palette entries, a palette shared between many images, and export of the palette in Doom format. The original project is on [GitHub](https://github.com/kornelski/pngquant). The compression engine is also available [as an embeddable library](https://github.com/ImageOptim/libimagequant).

## Usage

- batch conversion of multiple files: `d64quant *.png`
- one shared 256-color palette for many images, with a Doom palette file: `d64quant --global-palette --doompal --colors 256 *.png`
- Unix-style stdin/stdout chaining: `… | d64quant - | …`

To further reduce file size, try [oxipng](https://lib.rs/oxipng), [ImageOptim](https://imageoptim.com), or [zopflipng](https://github.com/google/zopfli).

## Features

 * High-quality palette generation
  - advanced quantization algorithm with support for gamma correction and premultiplied alpha
  - unique dithering algorithm that does not add unnecessary noise to the image

 * Configurable quality level
  - automatically finds required number of colors and can skip images which can't be converted with the desired quality

 * Fast, modern code
  - based on a portable [libimagequant library](https://github.com/ImageOptim/libimagequant)
  - C99 with no workarounds for legacy systems or compilers ([apart from Visual Studio](https://github.com/kornelski/pngquant/tree/msvc))
  - multicore support (via OpenMP) and Intel SSE optimizations

## Options

See `d64quant -h` for full list.

### `--quality min-max`

`min` and `max` are numbers in range 0 (worst) to 100 (perfect), similar to JPEG. d64quant will use the least amount of colors required to meet or exceed the `max` quality. If conversion results in quality below the `min` quality the image won't be saved (if outputting to stdin, 24-bit original will be output) and d64quant will exit with status code 99.

    d64quant --quality=65-80 image.png

### `--ext new.png`

Set custom extension (suffix) for output filename. By default `-or8.png` or `-fs8.png` is used. If you use `--ext=.png --force` options d64quant will overwrite input files in place (use with caution).

### `-o out.png` or `--output out.png`

Writes converted file to the given path. When this option is used only single input file is allowed.

### `--skip-if-larger`

Don't write converted files if the conversion isn't worth it.

### `--speed N`

Speed/quality trade-off from 1 (slowest, highest quality, smallest files) to 11 (fastest, less consistent quality, light comperssion). The default is 4. It's recommended to keep the default, unless you need to generate images in real time (e.g. map tiles). Higher speeds are fine with 256 colors, but don't handle lower number of colors well.

### `--nofs`

Disables Floyd-Steinberg dithering.

### `--floyd=0.5`

Controls level of dithering (0 = none, 1 = full). Note that the `=` character is required.

### `--posterize bits`

Reduce precision of the palette by number of bits. Use when the image will be displayed on low-depth screens (e.g. 16-bit displays or compressed textures in ARGB444 format).

### `--strip`

Don't copy optional PNG chunks. Metadata is always removed on Mac (when using Cocoa reader).

Without `--strip`, other PNG chunks are kept, including the `grAb` chunk that holds Doom sprite offsets. Use `--strip` only if you don't need the offsets.

### `--colors N` (or a bare number before the file names)

Maximum number of colors in the palette (2-256). `d64quant --colors 16 image.png` and `d64quant 16 image.png` are the same. With `--global-palette` it sets the size of the shared palette.

### `--trans-color HEX`

Sets the RGB color stored in the palette for fully transparent entries. The default is `000000` (pure black). Accepts `RRGGBB`, `#RRGGBB`, `0xRRGGBB` and the short form `#RGB`. Visible pixels are not affected. Quote the value if your shell treats `#` specially.

    d64quant --trans-color ff00ff image.png

### `--global-palette`

Builds ONE palette from all the input images, then converts every image with it, so all outputs share the same palette. Use `--colors N` to choose its size, for example 256, 128 or 16. Files are processed one after another with this option. It can't be used with stdin or `--map`.

    d64quant --global-palette --colors 128 *.png

### `--doompal` or `--doompal=file.pal`

Also saves the palette as a raw Doom palette: 256 colors of R, G, B in 768 bytes, the same layout as one palette of a PLAYPAL lump. Colors are in the same order as the PNG palette, unused entries are black, and transparent entries use the `--trans-color` color.

- With `--global-palette`, one `DOOMPAL.pal` is written next to the first input image.
- Without it, one `.pal` is written per output image, named after it (`image-fs8.png` gives `image-fs8.pal`).
- `--doompal=file.pal` sets the file name. It needs `--global-palette` or a single input file. The `=` is required.
- It can't be used when writing to stdout.

## Compiling

You will need to have a Rust toolchain and the C++ build environments installed on your machine.
- Rust: Download and run the installer from [Rustup](https://rustup.rs/) to install Rust 1.70 or later.
- Visual Studio Build Tools: Install the [Visual Studio Build Tools](https://visualstudio.microsoft.com/visual-cpp-build-tools/) (or Visual Studio Community). During setup, ensure that the Desktop development with C++ workload is checked, and that the Windows 10 or 11 SDK option is enabled.

When you have the code downloaded, and the prerequisites installed you can run the build.bat to compile the program to the release directory. Or you can open Windows PowerShell or command line in the main code directory. Then use the command "cargo build --release" to compile the code manually.

## License

d64quant is based on pngquant, which is dual-licensed:

* Under **GPL v3** or later with an additional [copyright notice](https://github.com/kornelski/pngquant/blob/master/COPYRIGHT) that must be kept for the older parts of the code.

* Or [a **commercial license**](https://supso.org/projects/pngquant) for use in non-GPL software (e.g. closed-source or App Store distribution). You can [get the license via Super Source](https://supso.org/projects/pngquant). Email kornel@pngquant.org if you have any questions.
