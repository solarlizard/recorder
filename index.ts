import * as proc from 'child_process'; 
import * as puppeteer from "puppeteer";

(async () => {

    const browser = await puppeteer.launch({headless: false,
        executablePath : '/opt/google/chrome/google-chrome',
        defaultViewport : null,
        ignoreDefaultArgs: ['--mute-audio', "--enable-automation"],
        args: [
            '--window-size=1920,1080',
            '--no-user-gesture-required',
            '--no-sandbox',
            '--disable-web-security',
            '--disable-features=IsolateOrigins',
            '--disable-site-isolation-trials',
            '--kiosk',
            '--disable-setuid-sandbox',
            '--allow-hidden-media-playback',
            '--use-fake-ui-for-media-stream',
            '--use-fake-device-for-media-stream'
        ] 
    });


    const page = await browser.newPage();
    
    await page.setViewport ({
        width : 1024,
        height : 768
    })

    page.on ('console', value => console.log (value.text ()))
    page.on ('error', error => console.error (error))

    page.on ('load', async () => {
        
        const ffmpeg = proc.spawn('ffmpeg', `-r 24 -f x11grab -s 1024x768 -draw_mouse 0 -i :99 -f alsa -i pulse -y /opt/vol/rec.mpg`.split (' '));
        
        ffmpeg.stderr.setEncoding('utf8');
        ffmpeg.stderr.on('data', data => console.log(data));    
        
        ffmpeg.stdout.on('data', data => console.log(data.toString()));

        ffmpeg.on ('spawn', async () => {

            await page.waitForSelector('.prejoin-preview-dropdown-container')
                .then (selector => selector?.click ())
        })
    })

    await page.goto('https://meet.jit.si/PageRecTest');
    

}) ()
    .catch (console.error)
