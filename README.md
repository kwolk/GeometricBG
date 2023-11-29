# GeometricBG
Generate geometric shapes

Randomly place colourful circles and hexagons to create a pleasing wallpaper.

#### WHY ####
My inspiration for this came from the artist Simon C. Page's illustration (found, down the rabbit hole known as Pintrest), which instantly appealed to me, given my own artistic background. However, Pintrest images are always too small, so I wanted to recreate this in vector to scale it to any sized device.

Rather than commit to learning a new software suite, only to recreate an immitation, I thought about how something similar could be achieved with a simple iPhone, thus allowing anybody to create their own unique version.


#### PROBABILITY ####
Deconstructing the design I was able to settle on the two most common shapes (circle and hexagon) and just five colours. Rondomising a shape's size, spacing, colour application, transparency level, even down to which of the two shapes to choose, all came down to probabilities.

#### COLOUR ####
```swift
private let colorProbabilities: [(UIColor, Int)] = [
    (UIColor(red: 244/255,  green: 177/255, blue: 21/255,   alpha: CGFloat.random(in: 0.1...0.4)), 3),  // YELLOW
    (UIColor(red: 225/255,  green: 84/255,  blue: 115/255,  alpha: CGFloat.random(in: 0.1...0.7)), 2),  // RUBY
    (UIColor(red: 80/255,   green: 159/255, blue: 177/255,  alpha: CGFloat.random(in: 0.1...0.5)), 1),  // TEAL
    (UIColor(red: 253/255,  green: 138/255, blue: 90/255,   alpha: CGFloat.random(in: 0.1...0.5)), 2),  // ORANGE
    (UIColor(red: 110/255,  green: 72/255,  blue: 131/255,  alpha: CGFloat.random(in: 0.1...0.7)), 1)   // PURPLE
]
```
Yellow, being a bright colour, was the most frequent colour to my eye in Page's original illustration, so that occured more than any other (3), whilst the darker teal and purple appearing more sparingly (1).

The transparency also varied to maintain the blended layers of the original: this time allowing the darker shades to punch through up to 70%, when they decided to show up.

After switching from an older (pre "Dark Mode") environment and onto a new one, it only dawned on me that there could be a dark mode for the app, which was something I had not considdered from Page's work, given that it was on a white canvas. But, when I saw the contrast, I knew that I had to retro-apply it into my mature codebase:

![effortLight](https://github.com/kwolk/GeometricBG/assets/114968/85740053-c1de-4241-a455-2cdb40a33501)
![effortDark](https://github.com/kwolk/GeometricBG/assets/114968/14a2d6fa-bd90-4f27-8105-d10911f19fee)

_the colours just pop !_


#### SHAPES ####
```swift
private let shapeProbabilities: [(ShapeType, Int)] = [(ShapeType.circle, 2), (ShapeType.hexagon, 1)]
```
It was clear form the Page's work that he favoured circular shapes over hexagons, so they appear at a 2:1 ratio.

```swift
let totalWeight = shapeProbabilities.reduce(0) { $0 + $1.1 }
        let randomValue = Int.random(in: 1...totalWeight)
        var sum = 0
        
        for (shape, weight) in shapeProbabilities {
            sum += weight
            if randomValue <= sum {
                
                return shape
```
Not satisfied with the true randomness of just probabilities alone, the Dictionary was to be mapped for randomness, which does a fair job for just a tap of the screen.
_choosing colours is also reliant on the map method_



#### SVG ####
Of course, the main output of the app was to be a vector graphic, which I could scale to any device that I had and on any platform (perhaps ever wallpaper in my bedroom.. one day).

For such a structured format, XML in Xcode was a little alchemic like (like localisation). Whilst and I had trouble kowing when to append the data for the 

```swift
svgPathStrings.append("<circle cx=\"\(positionX + radius)\" cy=\"\(positionY + radius)\" r=\"\(radius)\" fill=\"\(randomColourSVG)\" />\n")
```
Adding the code above at the end of creating a UIView circle (from a rectangle, stemming the touch location) will produce the SVG data entry below:
```XML
<circle cx="119.83806410518639" cy="148.3380641051864" r="64.16193589481361" fill="rgba(253, 138, 90, 0.48)" />
```
However, the process of a more complicated six sided shape demanded that the intersecting lines of a hexagon be added from start to finish, starting with an "M", followed by the co-ordinate data, and finalised with a "z" and the colour data:

```swift
var svgPathData = "M"
```
```swift
svgPathData += " \(corner.x) \(corner.y)"
```
```swift
svgPathData += " Z"
let pathElement = "<path d=\"\(svgPathData)\" fill=\"\(randomColourSVG)\" /> \n"
```
Even still, the troubles remain, with the rounded corners of the hexagon not faithfully mirrored in the SVG output data and their locations ill positioned:

![app](https://github.com/kwolk/GeometricBG/assets/114968/9daa5cd4-1345-499f-838c-7ae4108d89e6)
![svg](https://github.com/kwolk/GeometricBG/assets/114968/25e4d00b-ebf5-45a1-b548-7e400217d994)

Converting from RGB (UIKit) to string formatting output suitable for XML (SVG) formatting needed to be converted:
```swift
    // VALUES MUST BE VALID (0.0 to 1.0)
    let redValue    = max(0.0, min(1.0, red))
    let greenValue  = max(0.0, min(1.0, green))
    let blueValue   = max(0.0, min(1.0, blue))
    let alphaValue  = max(0.0, min(1.0, alpha))
    
    // EXTRAPOLATE SVG STRING FORMATTING FROM COMPONENT DATA
    let redInt      = Int(redValue * 255)
    let greenInt    = Int(greenValue * 255)
    let blueInt     = Int(blueValue * 255)
    let alphaFloat  = Float(alphaValue)
    
    let svgColourData = String(format: "rgba(%d, %d, %d, %.2f)", redInt, greenInt, blueInt, alphaFloat)
```

#### ONBOARDING ####
Although visually easy to fathom, the clarity of an upfront demonstration would be tollerated so long as it was fun to play along with. I had to break the DRY rule and moved a lot of existing functionality into a separat ViewController after conflicting issues, but this allowed for a tailored experience where I could segregate specific functionality to ensure the directions on screen were rewarded with the next stage of advice.

Employing the User Defaults class, a strict state machine logic driven system to e.g. prevent any gestures by the one directed on screen, along with being mindful of working on the main thread (DispatchQueue) to prevent memory leaks.

Onboarding restrictions : 
           <details>
           <summary>no swiping allowed: only tapping (once)</summary>
           ![1](https://github.com/kwolk/GeometricBG/assets/114968/694455d7-3049-42c5-861d-2e0bbe858117)
           </details>
           <details>
           <summary>no swiping allowed: save to Library request permission</summary>
           ![2](https://github.com/kwolk/GeometricBG/assets/114968/ffd876a1-1c4e-46fe-81e0-2e7c527dfbb2)
           </details>
           <details>
           <summary>only down swiping allowed (visually removes shape)</summary>
           ![3](https://github.com/kwolk/GeometricBG/assets/114968/2e0d6a8d-31c7-46ea-870d-1f490fa00861)
           </details>
           <details>
           <summary>no swiping allowed: shake gesture only</summary>
           ![4](https://github.com/kwolk/GeometricBG/assets/114968/6eab6681-bd23-4674-8322-22f7241bed5b)
           </details>
           <details>
           <summary>left swiping only: dark mode</summary>
           ![6](https://github.com/kwolk/GeometricBG/assets/114968/ecfe402d-b789-4e8b-b5bb-13347728c67e)
           </details>

Designing the app to respect user's global settings it will open in Dark mode if that is set (and visa-versa). However, I had to invert the option during onboarding of course, which added complexity:
```swift
    // NORMAL FUNCTIONALITY TO MIMIC USER MODE SETTINGS
    if self.traitCollection.userInterfaceStyle == .light && !inverted {
        changeBackground(toColour: .white)
    } else if self.traitCollection.userInterfaceStyle == .light && inverted {
        changeBackground(toColour: .black)
    }
    
    // WORKAROUND : ONBOARDING REQUIRES DEMO OF ALTERNATE MODE, SO INVERSION IS TEMPORARILY NEEDED
    if self.traitCollection.userInterfaceStyle == .dark && !inverted {
        changeBackground(toColour: .black)
    } else if self.traitCollection.userInterfaceStyle == .dark && inverted {
        changeBackground(toColour: .white)
    }
```
```swift
  if UIApplication.shared.supportsAlternateIcons {
      
      // SET ICON TO MIMIC LIGHT / DARK SETTING (WORKAROUND : ONLY CHANGE IF ICON DIFFERS FROM MODE, TO AVOID NAGGING)
      if self.traitCollection.userInterfaceStyle == .dark && iconLight {
          UIApplication.shared.setAlternateIconName("AppIconDark")
          UserDefaults.standard.set(false, forKey: "IconLight")
      } else if self.traitCollection.userInterfaceStyle == .light && !iconLight {
          UIApplication.shared.setAlternateIconName(nil)  // RESET TO DEFAULT (LIGHT)
          UserDefaults.standard.set(true, forKey: "IconLight")
```
Overall, after several revisions, the onboarding state machine I employ here is highly customised. However, I do intend to develop an interactive system flexible enough to re-use...

#### LOCALISATION ####

Much like SVG's implementation into Xcode, Localisation is a little bit of an oddity. To get it working best I found the Enumeration method from Mendy Barouk on Medium a valuable shortcut to avoide mistakes:

```swift
enum OnboardingLocalisation: String {
    
    case onboarding1, onboarding2, onboarding3, onboarding4, onboarding5a, onboarding5b, onboarding6a, onboarding6b, onboarding7
    
    var localised: String {
        NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
    }
```
All that however still leaves me wondering what went through Apple's mind when implcitly implementing String values for definitions:

```swift
"OnboardingLocalisation_onboarding3" = "swipe down to remove";
"OnboardingLocalisation_onboarding3" = "desliza el dedo hacia abajo para eliminar";
```


#### EASTER EGG #1 ####

To complement the original I added in a hidden feature, not detailed during the Onboarding process (swipe up), to mimic the original geometric feel with a wire mesh overlay:

![mio](https://github.com/kwolk/GeometricBG/assets/114968/817564f1-ceb0-4166-9f42-783c17e067b7)
![SimonCPage](https://github.com/kwolk/GeometricBG/assets/114968/7c0e9b21-d48f-4048-959c-cbad441c765c)

```swift
let context = UIGraphicsGetCurrentContext()
        
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.setAlpha(1)
        context?.setLineWidth(0.1)
        
        let gridSpacingX: CGFloat = 60.0
        let gridSpacingY: CGFloat = 30.0
        let rectWidth   : CGFloat = 60.0
        let rectHeight  : CGFloat = 30.0
        
        for x in stride(from: 0, through: self.frame.width, by: gridSpacingX) {
            for y in stride(from: 0, through: self.frame.height, by: gridSpacingY) {
                
                // RECTANGLES
                context?.stroke(CGRect(x        : x,
                                       y        : y,
                                       width    : rectWidth,
                                       height   : rectHeight))
                
                // DIAGONAL LINES
                context?.move(to: CGPoint(x: x, y: y))
                context?.addLine(to: CGPoint(x: x + rectWidth,
                                             y: y + rectHeight))
                context?.strokePath()
                
                context?.move(to: CGPoint(x: x + rectWidth,
                                          y: y))
                
                context?.addLine(to: CGPoint(x: x,
                                             y: y + rectHeight))
                context?.strokePath()
```
Given the nature of input (a blunt instrument) I felt that the cartoonish proportions fit the medium, and likely client base, well. Otherwise it would have been a direct copy, rather than an exercise is deconstruction.

#### EASTER EGG #2 ####

I always loved the idea of changing app icons, even before I knew that I could do it (a habbit back from the ald days, before security) and absolutely wanted to find a reason to do it.

Unfortunately there is no way to do so silently, so an alert will display notifying the user of the change, which occurs if the app is opened in a different global state to that of which it was last i.e. from Light to Dark mode:

![icon - light (mode) png](https://github.com/kwolk/GeometricBG/assets/114968/1e536885-da50-4216-ae0f-833bd344b5f0)
![icon - dark (mode)](https://github.com/kwolk/GeometricBG/assets/114968/51a4245a-8b53-4f4e-8f41-0cfaa06928b9)

_it will automatically trigger when the user opens the app_


_I really had a nice time writing this to the backing music of "The Chronicles of Narnia - Aslan's Camp Ambience & ASMR" (watch?v=3A1a6mKmXGE)_
