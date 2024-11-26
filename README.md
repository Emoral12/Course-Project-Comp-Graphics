# Course-Project-Comp-Graphics
Course Project for Intro to Computer Graphics 40144

Game Premise: Junkyard Defense is a 3D first-person shooter where you play as a crazy hobo living in a junkyard known as New York City. Inside of New York City, lies a large junkyard full of various trash heaps and scrap. However, the filthy and rough exterior of the junkyard does not deter our player character, who has made his home and base of operations insde the dirty and vast junkyard, staying away form the world's troubles by locking themselves away from the world withing the safe concrete walls of the junkyard. However, a threat approaches the junkyard, now you must defend your home and private property from a terrible invasion of giant rats roaming the streets of New York City. It is up to you, the player, to stop the rats from killing you for them to seize your beautiful junk-filled home.

## Written Explanation for Shader "Custom/AmbientLighting"
1. Overview of the Shader
The "Custom/AmbientLighting" shader is designed to create a dynamic lighting effect in a scene, blending ambient and diffuse lighting. It emphasizes the realism and depth of 3D objects by combining basic diffuse reflection and ambient lighting while allowing for customization through a user-defined color property.

2. Purpose of the Shader
This shader provides a lightweight and customizable lighting solution that can be applied to various objects in the scene. It offers:

Realism: By incorporating ambient lighting, it mimics the soft, global illumination seen in real-world environments.
Flexibility: The customizable _Color property allows for artistic control over the object's final appearance, aligning with specific scene aesthetics.
Performance: By using basic calculations and avoiding heavy operations like specular highlights or shadows, it remains computationally inexpensive.

3. Implementation Details
The shader consists of vertex and fragment programs written in CG/HLSL. Each component contributes to its functionality:

Properties Section
_Color: A user-defined RGB color that influences the object’s final appearance.
Example Use: Tinting objects to match the environment or emphasize thematic colors in the game (e.g., greenish tones for mutant rats).
Vertex Shader (vert Function)
Input: The vertex position (v.vertex) and normal (v.normal) are provided.
Normal Transformation:
The normal vector is transformed into object space using unity_WorldToObject.
This ensures lighting calculations respect the object's orientation.
Light Direction and Attenuation:
The light direction (_WorldSpaceLightPos0) is normalized.
Diffuse reflection is calculated using Lambert’s cosine law: dot(normalDirection, lightDirection).
Unity's ambient lighting (UNITY_LIGHTMODEL_AMBIENT) is added to simulate global illumination.
Output:
The vertex color (o.col) is a blend of ambient light, diffuse reflection, and the user-defined color.
The position (o.pos) is transformed to clip space for rendering.
Fragment Shader (frag Function)
The interpolated color from the vertex shader is directly output as the fragment's color. This ensures smooth lighting across the surface.
Fallback
The shader falls back to Unity’s standard "Diffuse" shader if not supported by the hardware. This ensures compatibility.

4. Sales Pitch and Scene Benefits
This shader was tailored specifically to enhance the appearance of game objects by adding believable lighting which blends naturally into the scene. Furthermore, it can provide excellent lighting for the various trash objects located around the game area.

5. Supporting Materials (Diagram)

> Vertex Input (Position, Normal)

     ↓
Transform Normal to Object Space

     ↓
Calculate Light Direction

     ↓
Compute Diffuse Reflection (Lambert's Law)

     ↓
Add Ambient Lighting

     ↓
Apply User-Defined Color (_Color)

     ↓
Output Vertex Color and Clip-Space Position

7. Why This Implementation Stands Out Compared to class or lab examples
Custom Normal Transformation: The shader explicitly normalizes and transforms normals to object space for precision, which may not have been a focus in simpler examples.
Ambient and Diffuse Combination: Unlike basic shaders, this shader balances multiple lighting components.
User Customization: The _Color property provides artistic flexibility, which is often omitted in standard examples.
This shader overall makes the game objects lying in the background stand out with an air of realism and uniqueness to their shining light reflections.

## Written Explanation for Shader "Custom/BumpMapping"
1. Overview of the Shader
The "Custom/BumpMapping" shader is a surface shader designed to add visual depth and detail to a 3D object by using a normal (bump) map. It achieves this without altering the object's geometry, instead manipulating how light interacts with the surface to create the illusion of texture.

2. Purpose of the Shader
This shader enhances the realism of your scene by:

Simulating small-scale surface details such as cracks, dents, or textures on objects.
Allowing developers to control the intensity of the bump effect via a slider property (_mySlider).
Enabling separate diffuse and bump texture maps for fine-grained control over an object's appearance.
This is particularly beneficial in the mutant rat invasion game to make surfaces like rat skin, broken pavement, or worn walls appear more lifelike.

3. Implementation Details
The shader combines diffuse texturing with bump mapping using Unity's surface shader system. It offers customization through exposed properties and incorporates user-defined and Unity-provided functionality.

Properties Section
_myDiffuse: A 2D texture representing the object's base color or albedo.
_myBump: A normal (bump) map defining the surface irregularities.
_mySlider: A scalar value controlling the intensity of the bump effect (range: 0 to 10).
SubShader Section
The shader uses the Lambert lighting model, which is efficient and suitable for diffuse lighting scenarios.
Surface Shader Function (surf)
Inputs:

IN.uv_myDiffuse: UV coordinates for the diffuse texture.
IN.uv_myBump: UV coordinates for the bump map.
Diffuse Texture Application:

The albedo (o.Albedo) is set to the color fetched from the diffuse texture using tex2D.
Normal Mapping:

The bump map is unpacked using UnpackNormal, converting the 2D texture data into a format suitable for lighting calculations.
The unpacked normal is multiplied by _mySlider to control the intensity of the bump effect.
Output:

The shader passes the modified normal and albedo to Unity's lighting pipeline for rendering.
Fallback
If the shader is unsupported, it falls back to Unity's standard "Diffuse" shader, ensuring compatibility.

4. Sales Pitch and Scene Benefits
This shader plays a vital role in creating a gritty, immersive environment for the mutant rat invasion game. With the help of bump mapping two key textures are made more realistic and gritty, the brick walls surrounding the junkyard and the rat fur. With the help of bump mapping one can alter and modify the bumps of a normal map to accentuate key or important aspects of textures, such as the individual fur and hairs of the rats or make the individual bricks of a brick wall stand out.

5. Supporting Materials (Graph)
Input UV Coordinates (Diffuse, Bump)
     ↓
Fetch Diffuse Texture Color (tex2D)
     ↓
Fetch and Unpack Normal Map (UnpackNormal)
     ↓
Modify Normal with Bump Slider (_mySlider)
     ↓
Output Albedo and Modified Normal for Lighting Calculations

6. Why This Implementation Stands OutCompared to class or lab work
Dynamic Control: The _mySlider property enables real-time adjustment of bump intensity, offering versatility that was not emphasized in standard examples.
Context-Specific Use: This shader was customized for the game's needs, focusing on rough, gritty surfaces to enhance the rat invasion and the junkyard theme.
Enhanced Texturing: The dual-texture approach (diffuse and bump) ensures surfaces are both visually rich and thematically appropriate.

## Written Explanation for Shader "Custom/GlassWithOutline"
1. Overview of the Shader
The "Custom/GlassWithOutline" shader combines two essential effects for creating a glass-like material with a visible outline. The shader includes an outline effect that gives objects a glowing or highlighted outline and a glass effect that simulates transparency and surface details like reflections or refractions. This is ideal for creating visually striking objects like glass, windows, or mystical objects with transparent, reflective surfaces.

2. Purpose of the Shader
This shader provides two main features for 3D objects:

Glass Effect: Simulates the appearance of transparent surfaces with a normal map for added detail, enhancing visual depth and realism.
Outline Effect: Adds a colorful, adjustable outline to the object, making it stand out against its surroundings. This is particularly useful for emphasizing important objects or characters in your game (e.g., an important item or a boss character).
In the context of your mutant rat invasion game, this shader could be used for:

Glass Windows or Shattered Glass: Mimicking the look of shattered glass, broken windows, or reflective surfaces in the urban environment.
Highlighting Objects: Important items or key objects (like power-ups or obstacles) can have a glowing outline to attract player attention.

3. Implementation Details
This shader uses two passes:

Outline Pass: Creates the visible outline effect.
Glass Pass: Renders the glass material with transparency and surface details like normals from the bump map.
Properties Section
_MainTex: The main diffuse texture for the object (e.g., the glass texture or the texture for the object being outlined).
_BumpMap: A normal map to simulate surface detail, such as slight irregularities or imperfections.
_OutlineColor: The color of the outline, typically a bright color like blue or red, adjustable to match the desired visual theme.
_OutlineWidth: The width of the outline. A larger value will create a thicker outline around the object.
_ScaleUV: Controls the scale of the normal map to adjust the perceived intensity of surface details.
SubShader Section
Tags and GrabPass:
The Queue tag is set to "Transparent," ensuring the shader is rendered after opaque objects, suitable for transparent materials like glass.
The GrabPass directive is used to capture the current frame's scene as a texture, which is then used to create the glass effect.
Outline Pass
This pass renders the outline around the object:

Cull Front: Inverts the culling, meaning that the front faces of the object are discarded and the back faces are used to render the outline. This ensures that the outline is visible from the outside.
Vertex Shader (vert function):
The object's vertex positions are expanded along the object's normals to push the vertices outward, creating a "bigger" version of the object that will serve as the outline.
The normal direction is transformed to world space using the unity_ObjectToWorld matrix.
The outline is drawn by moving the vertices outward by a value of _OutlineWidth along their normals.
Fragment Shader (frag function):
The outline color (_OutlineColor) is applied to the expanded object to create the outline effect.
Glass Pass
This pass renders the glass material with transparency and surface details:

Vertex Shader (vertGlass function):
Sets up the UV coordinates for both the main texture (_MainTex) and the bump map (_BumpMap).
The GrabPass texture coordinates are calculated and passed along for later use in the fragment shader.
Fragment Shader (fragGlass function):
Bump Mapping: The bump map is unpacked to get the normal offset, and this is used to create an offset for the grab texture (captured scene texture) based on the bump map.
Grab Texture: The GrabTexture stores the scene’s image, which is then applied to the glass object to simulate reflections or refractions. The bump map details influence how the texture is applied to the surface.
Transparency: The final color is a blend of the grab texture and the object's main texture, achieving the transparent appearance with some reflection effect.
Fallback
If the shader is unsupported, it falls back to Unity’s standard "Diffuse" shader for compatibility.

4. Sales Pitch and Scene Benefits
This shader adds visual interest and immersion to your scene by combining transparency and outline effects in a single material. It can be used creatively to highlight key elements in your game, making them more noticeable while maintaining a realistic glass-like effect. It specifically was implemetned to create unique and vibrant health pickup items, these being alcohol bottles the player will ifnd located around the game area, rather than the simplistic use of basic 3D shapes for hitpoint pickups. Through the use of outline shaders, players can note the game objects aren't simple decorations but important game objects that can help them. Furthermore, the glass appearance of bottles will add a hint of realism, instead of the bottle pickups being plain solid colors they will resemble actual beer bottles.

5. Supporting Materials (Diagram)
Input: Object Vertices and Normals
    ↓
Outline Pass:
        Expand Vertex Positions along Normals (using _OutlineWidth)
        Apply Outline Color
    ↓
Glass Pass:
        Fetch Scene Image (GrabPass)
        Fetch Diffuse and Bump Map Textures
        Apply Normal Mapping to Displace Texture Coordinates
        Blend Scene Reflection with Object Texture (with transparency)

6. Why This Implementation Stands Out Compared to class or lab work
Dual Pass System: The shader combines two distinct effects (outline and glass) in a single shader, a technique that is more advanced than typical shaders seen in introductory material.
Realistic Reflections: The use of the GrabPass for reflection gives the shader a more dynamic and realistic effect, adding a layer of realism to glass surfaces in the game.
Interactive and Highlighted Objects: The outline effect is useful for making interactive or critical objects stand out, a feature that adds functionality and design flexibility not usually found in basic shaders.

Written Explanation for Shader "Custom/Concrete"
1. Overview of the Shader
The "Custom/Concrete" shader is designed to simulate a simple concrete-like material, with a focus on texture application, color manipulation, and basic scaling adjustments for the surface properties. The shader takes multiple properties that allow it to be customized for different visual results, such as adjusting the color, range, texture, and float/vector parameters. It is a flexible shader that can be used in different environments, ideal for surfaces like concrete pavements, walls, and other rough materials in the game.

2. Purpose of the Shader
This shader's primary objective is to provide a customizable concrete surface. The combination of a texture (_myTex), a range modifier (_myRange), and color (_myColor) makes it versatile for different concrete materials, from polished to rough surfaces. This shader could be used for various elements in your game, such as:

Concrete Streets or Pavement: Given your game's setting in New York with mutant rats invading the streets, you can apply this shader to simulate urban environments like roads, sidewalks, or plazas.
Industrial or Post-Apocalyptic Structures: Use this shader for walls or broken-down infrastructure that has aged or decayed.
The shader also introduces an interesting element by using vectors (_myVector) and floats (_myFloat), which could potentially be expanded to create more complex surface behaviors, like roughness or advanced lighting effects.

3. Implementation Details
Properties Section
_myColor: This property allows the color of the surface to be customized. It's useful for giving the concrete material a tint or hue, simulating different types of concrete (gray, brownish, or even stained).

_myRange: This is a scaling factor for the texture. It multiplies the texture, making it appear larger or smaller, which can help create variations in the texture’s scale for different concrete surfaces (e.g., cracked vs. smooth concrete).

_myTex: This is the primary texture applied to the surface. It represents the concrete texture, which can be anything from a rough concrete surface to a smooth one, depending on what you choose.

_myFloat: This property isn't used in the code but provides an example of how you might incorporate float values to influence other surface attributes, like roughness or shininess.

_myVector: Similarly, the vector is defined but isn't utilized in the code. However, it could represent multiple vector-based properties, like tiling factors or vectorized offsets for normal mapping or additional surface variations.

SubShader Section
Surface Shader (#pragma surface surf Lambert):
This directive defines that the shader will use Lambert lighting, which is a simple diffuse reflection model. It is ideal for rough surfaces like concrete, where the light scattering is relatively uniform.
Shader Behavior
surf function:
This is the main function responsible for defining how the surface looks. The function calculates the Albedo, which is the color of the surface, by applying the texture to the object's surface coordinates.
Texture Sampling: The texture is sampled with tex2D(_myTex, IN.uv_myTex), which fetches the color from the texture at the given UV coordinates.
Scaling the Texture: The texture’s color is then multiplied by _myRange, which scales the result. If _myRange is higher, the texture color becomes more intense; if lower, the texture becomes dimmer or darker.
Overall Structure
The shader is relatively simple, applying a texture to a surface and scaling it based on the _myRange parameter. It doesn't modify other aspects like specular reflections, normal mapping, or advanced lighting, which would typically be added to give a more realistic concrete effect.

4. Sales Pitch and Scene Benefits
The "Custom/Concrete" shader provides an essential tool for creating urban environments in the game, especially for surfaces like roads, sidewalks, and buildings. In the context of your game, where you defend a large concrete-fortified junkyard, this shader allows for:

Customization and Flexibility: The shader's various properties, such as _myColor, _myRange, and _myTex, offer flexibility in designing different types of concrete surfaces. For example, you can easily create variations of cracked, aged concrete with different tints, or create smoother pavement for city roads.

Scalability for Diverse Concrete Surfaces: The ability to scale the texture with _myRange means that you can adjust the appearance of the concrete to match different scenarios. Whether you want large, pronounced details or a smoother appearance, the shader can accommodate those needs.

Realism with Basic Customization: While the shader is simple, it can be highly effective when used creatively. You can use it in combination with other shaders, like normal mapping or bump mapping, to simulate surface imperfections or simulate wear and tear on the concrete surfaces of the streets.

Easy Integration into Game Environments: Given that your game is set in a post-apocalyptic city overrun by mutant rats, the shader helps create a gritty, realistic environment. It can easily be applied to streets, walls, and even indoor spaces, adding to the immersion of the urban chaos.

Efficient Performance: Since this shader is straightforward, it is highly efficient and should perform well even when applied to large areas of concrete surfaces.

5. Supporting Materials (Diagram)
Input: Object's UV Coordinates
    ↓
Texture Sample: tex2D(_myTex, IN.uv_myTex)
    ↓
Albedo Color Calculation: 
    (Texture Color * _myRange) -> Output to Surface
   
6. Why This Implementation Stands Out Compared to class or lab work:

Customization via Shader Properties: This shader goes beyond simple texture mapping by offering the flexibility to adjust both the color and scaling of the texture using the _myColor and _myRange properties. This provides an easy way to create variations in concrete surfaces, which is a step toward more dynamic, environment-specific shaders.

Scalability and Flexibility: While simple, this shader is easy to expand. You could integrate it with other shaders or features (such as bump mapping or ambient occlusion) to create a more complex concrete surface.

## Written Explanation for Shader "Custom/TextureScroll"
1. Overview of the Shader
The "Custom/TextureScroll" shader is a dynamic surface shader designed to create the illusion of movement or animation by scrolling two textures across a surface. By manipulating the UV coordinates of the textures, this shader enables both textures to move independently, creating effects such as static interference, water ripples, or moving energy patterns. The shader allows developers to control the scrolling speed for each texture layer, offering versatility in how motion is perceived on the surface.

This shader uses Unity's Lambert lighting model for basic diffuse shading, making it efficient while providing an animated visual effect.

2. Purpose of the Shader
The primary purpose of the "Custom/TextureScroll" shader is to enhance visual dynamics in the game by introducing animated surface effects. These effects can be used in various scenarios, such as:

Simulating Moving Patterns: Ideal for surfaces like energy shields, magical effects, or flowing liquids.
Static Screens and Interference: Perfect for creating the illusion of moving static on TV screens or malfunctioning devices.
Environmental Immersion: Adds life to environments, such as flowing rivers or shifting sands.
In the context of your New York mutant rat game, this shader could be applied to:

Flickering monitors in abandoned labs or subway stations.
Flowing sewer water or toxic sludge in underground tunnels.
Magical or sci-fi effects on interactive objects like weapons or devices.

3. Implementation Details
Properties:

_MainTex: The primary texture applied to the surface, representing the base layer of the scrolling effect.
_OverlayTex: A secondary texture layered over the main one, adding complexity and variation.
_ScrollX: Controls the horizontal scrolling speed for both textures.
_ScrollY: Controls the vertical scrolling speed for both textures.
SubShader:
Uses the Lambert lighting model, providing basic diffuse lighting for a balanced and efficient rendering process.

Shader Behavior:

Dynamic UV Adjustment:

The texture coordinates (IN.uv_MainTex) are modified by adding offsets based on _ScrollX and _ScrollY, which are multiplied by Unity's _Time variable to ensure consistent animation over time.
Blending Textures:

The primary and secondary textures are sampled at their respective UV coordinates. The secondary texture scrolls at half the speed of the primary texture to create a layered effect.
The two textures are blended together by averaging their RGB values.
Final Output:

The blended result is assigned to the Albedo, defining the surface's diffuse color.

4. Sales Pitch and Scene Benefits
This shader allows for otherwise static textures and objects to act and behave in a visually dynamic way that makes the scene feel more alive. It is used for the game to enhance the appearance of a scraped and salvaged TV, making an otherwise mundane quadrilateral object a dynamic and interesting game object.

5. Supporting Materials
Input: Object's UV Coordinates + Scroll Speeds
    ↓
Texture Sampling:
    - Primary Texture: tex2D(_MainTex, IN.uv_MainTex + float2(_ScrollX, _ScrollY))
    - Secondary Texture: tex2D(_OverlayTex, IN.uv_MainTex + float2(_ScrollX/2, _ScrollY/2))
    ↓
Blending: Combine Primary and Secondary Textures
    (Primary RGB + Secondary RGB) / 2
    ↓
Output: Albedo

6. Why This Implementation Stands Out Compared to class or lab work
Introduction of Motion: This shader goes beyond static textures by dynamically animating them, adding life to game surfaces.
Layered Effects: The combination of two independently scrolling textures creates depth and visual complexity.
Practical Applications: Demonstrates how shaders can be used creatively to enhance immersion and storytelling, aligning with the environmental narrative of your mutant rat game.
Ease of Expansion: Can be extended with features like normal mapping or emissive properties for glowing effects, further enriching its utility.

## Written Explanation for Shader "Custom/ToonShader"
1. Overview of the Shader
The "Custom/ToonShader" is a surface shader that creates a cartoonish, cel-shaded effect by applying a gradient ramp texture to control how lighting appears across the surface. This shader replaces smooth shading transitions with discrete lighting bands, producing a stylized, non-photorealistic look reminiscent of classic cartoons or anime. It utilizes a custom lighting model, ToonRamp, to achieve this visual effect, combining artistic stylization with Unity's shader framework for efficient rendering.

2. Purpose of the Shader
The primary goal of the "Custom/ToonShader" is to provide a stylized shading effect suitable for cartoonish or cel-shaded environments. It simplifies lighting to focus on bold, discrete shading bands, emphasizing shape and contour over realistic light behavior.

Potential uses in your mutant rat game include:

Character Designs: Create unique, stylized characters or NPCs that stand out visually.
Interactive Elements: Apply the shader to highlight key items or objects, such as tools, signage, or interactive panels.
Stylized Visual Effects: Use on magical or sci-fi assets to convey a more playful, non-realistic aesthetic, contrasting with other gritty elements.

3. Implementation Details
Properties:

_Color: Defines the base color of the object, applied uniformly to the surface.
_RampTex: A gradient ramp texture used to control how lighting transitions across the surface.
Custom Lighting Model:
The shader employs a unique lighting function, LightingToonRamp, which maps the surface's diffuse lighting value (dot(s.Normal, lightDir)) onto the ramp texture.

Shader Behavior:

Input Setup:

The shader receives the surface's normal vector (s.Normal) and the light direction (lightDir) in world space.
Lighting Calculation:

Computes the dot product of the normal and light direction to determine how light hits the surface. This value is remapped into the range [0, 1] and used to sample the ramp texture.
Ramp Sampling:

The ramp texture is sampled to retrieve a color corresponding to the light intensity at a specific location. This sampling effectively replaces smooth shading gradients with discrete bands of light and shadow.
Final Output:

Combines the ramp-based lighting result with the surface's base color (_Color), producing the stylized toon effect.

4. Sales Pitch and Scene Benefits
The stylized and cartoony appearance of a toon shader (once implemented to a game object) will enhance the appearance of objects and accentatue the goofy and outlandish game premise. Furthermore, it is utilized for the tails of the giant rat enemies, which allows for players to spot the otherwise dark and covert critters with ease (as the vibrant toon pink of their tail will pop out in the otherwise dull andcool colors of the junkyard).

5. Supporting Materials (Diagram)
Input: Normal Vector, Light Direction
    ↓
Lighting Calculation:
    - Dot Product: dot(s.Normal, lightDir)
    - Remap: Range adjusted to [0, 1]
    ↓
Ramp Sampling:
    - Use remapped value to fetch color from _RampTex
    ↓
Final Shading:
    - Multiply Ramp Color with _Color
    ↓
Output: Toon-Shaded Albedo

6. Why This Implementation Stands Out Compared to class or lab work:
Custom Lighting Integration: Implements a custom lighting model (LightingToonRamp), showcasing how lighting models can be tailored to achieve specific artistic effects.
Stylization Over Realism: Moves beyond standard surface shading by incorporating artistic control via ramp textures, providing versatility for game aesthetics.
Flexible Expansion: The shader can be extended with additional features, such as emissive properties for glowing edges or outlines for a fully cel-shaded style

## Written Explanation for Shader "Custom/LambertLightingTwo"
1. Overview of the Shader
The "Custom/LambertLightingTwo" shader provides a basic diffuse lighting model with an emphasis on utilizing the Lambert lighting technique. This shader calculates light interaction using normals and light directions in world space, resulting in a simple but effective shading model. It modifies the base Lambert model to incorporate per-vertex lighting and attenuation for a customizable diffuse reflection effect, ideal for rendering basic surfaces.

2. Purpose of the Shader
The shader is designed to demonstrate a fundamental implementation of Lambert lighting with added customization through user-defined color (_Color) and support for attenuation.

Potential uses in your game include:

Simple Character or Object Lighting: Apply to game objects such as static props or background elements that don’t require complex shading.
Environmental Assets: Use for walls, basic terrains, or other elements where diffuse lighting suffices.
Learning Tool: Serves as a foundational shader to understand diffuse lighting calculations and extend into more advanced techniques.

3. Implementation Details
Properties:

_Color: Sets the base color of the object and serves as the multiplier for lighting calculations.
Shader Behavior:

Vertex Function (vert):

Normal Transformation: The normal vector is transformed into world space using unity_WorldToObject.
Light Direction Calculation: Normalized light direction (_WorldSpaceLightPos0) is computed for interaction with the transformed normals.
Diffuse Reflection: The Lambert term, max(0, dot(normalDirection, lightDirection)), calculates the intensity of light hitting the surface based on the angle between the normal and light direction.
Fragment Function (frag):

Combines the diffuse reflection term with the light color (_LightColor0) and the object’s base color (_Color).
Outputs the final color to the screen, applying ambient lighting for additional realism.
Lighting Model:

Uses a simplified Lambert model, which assumes equal light scattering in all directions, making it suitable for dull or matte surfaces.
Output Structure:
The shader renders objects with diffuse lighting effects that accurately represent surface interactions with a light source while maintaining performance.

4. Sales Pitch and Scene Benefits
Efficient Lighting for Matte Surfaces: This shader provides high-performance lighting for surfaces that don’t require specular highlights or advanced materials. Perfect for urban assets like concrete walls, rubble, or basic debris.

Customization Options: By modifying the _Color property, you can adapt this shader to fit a variety of asset types, from neutral gray backgrounds to more vibrant colors for interactive props.

Simplicity with Room for Expansion: The code offers a clear and modular structure, making it easy to enhance. Add additional features, like normal mapping or environmental reflections, as your project grows.

Applications in Your Game:

Environmental Props: Apply to non-interactive background elements like walls or street surfaces.
Dynamic Lighting Demonstrations: Use for objects under dynamic light sources to showcase smooth, consistent shading.

5. Supporting Materials
Vertex Stage: 
    Input: Object's Vertex and Normal
        ↓
    Normal Transformation:
        - Transform normal to world space
        - Normalize for consistent calculations
        ↓
    Diffuse Reflection:
        - Calculate Lambert term (dot(normal, lightDir))
        ↓
    Output: Pass color and position to fragment stage

Fragment Stage:
    Input: Vertex Output (color and position)
        ↓
    Final Lighting:
        - Combine diffuse term with base color and light color
        ↓
    Output: Final Surface Color

6. Why This Implementation Stands Out Compared to class or lab work
Manual Lighting Calculations: Unlike pre-built Unity surface shaders, this implementation calculates Lambert lighting from scratch, demonstrating the core concepts behind diffuse reflection.
Focus on Performance: Optimized for simpler surfaces, this shader is ideal for large scenes with many assets, minimizing computational overhead.
Expandable Framework: Serves as a foundational shader that can easily be modified or extended to include specular highlights, normal mapping, or additional lighting effects.

## Written Explanation for Shader "Custom/ColorGradingShader"
1. Overview of the Shader
The "Custom/ColorGradingShader" is a post-processing shader designed to apply color grading effects to a scene. This effect is achieved by blending the scene’s rendered image with a Look-Up Texture (LUT). The shader manipulates the scene's color tones based on the LUT to achieve cinematic or stylized visual effects, offering a highly customizable grading process. It is applied via a script that is attached to the camera, ensuring the effect is applied to the entire viewport.

2. Purpose of the Shader
The shader’s primary objective is to enhance the visual quality of the scene by applying customizable color grading. Its features include:

Artistic Adjustments: Stylize the game’s visual tone, creating moods like warmth, cold, or dystopian aesthetics.
Realism or Fantasy: Adjust the visuals to better fit the narrative, whether gritty realism for urban environments or surreal tones for fantasy settings.
Dynamic Grading: Using the _Contribution property, the effect can be blended dynamically, enabling smooth transitions between ungraded and graded visuals.
In the context of your game with giant mutant rats invading New York:

Create a grim, dystopian tone for the post-apocalyptic setting by applying muted or gritty LUTs.
Use grading dynamically during events, such as applying desaturated grading in tense moments or vibrant hues after victories.

3. Implementation Details
Properties:

_MainTex: The texture representing the rendered scene from the camera.
_LUT: The Look-Up Texture, used to remap the colors of the scene.
_Contribution: A blending factor that determines the intensity of the color grading effect.
Shader Behavior:

Vertex Function (vert):

Passes UV coordinates and vertex positions from the input (appdata) to the fragment shader.
Fragment Function (frag):

Color Sampling: Samples the scene texture (_MainTex) to retrieve the ungraded pixel color.
LUT Sampling: Uses the LUT texture to remap the colors based on the original RGB values.
Blending: Applies linear interpolation (lerp) between the original color and the graded color based on the _Contribution value.
Key Techniques:

LUT Positioning: Each pixel color's red, green, and blue values determine its corresponding position in the LUT texture. The shader computes the LUT position (lutPos) dynamically.
Threshold and Offset Calculation: Ensures smooth blending by managing LUT texel alignment and transitions between LUT cells.
Output:

Produces a color-graded scene by blending the original scene color with the LUT-adjusted color.

4. Sales Pitch and Scene Benefits
Flexible Aesthetic Control: By modifying the LUT, you can completely change the game’s visual tone. For instance:

Apply gritty, muted LUTs for the urban chaos of New York’s most rat-infested junkyard.
Use vibrant, oversaturated LUTs for dreamlike sequences or vibrant zones.
Dynamic Adjustments: The _Contribution parameter allows smooth transitions between ungraded and graded views, useful for cutscenes, power-ups, or in-game events.

Performance Optimization: The LUT-based method is computationally efficient compared to real-time color adjustment methods, making it suitable for high-performance gameplay.

5. Supporting Materials
Input: Scene Texture (_MainTex) and Look-Up Texture (_LUT)
    ↓
Fragment Shader:
    - Sample Original Color: tex2D(_MainTex, i.uv)
    - Compute LUT Position:
        -> Calculate cell, xOffset, and yOffset based on RGB values
        -> Combine into LUT Position (lutPos)
    - Sample LUT Texture: tex2D(_LUT, lutPos)
    - Blend Colors: lerp(originalColor, gradedColor, _Contribution)
    ↓
Output: Final Graded Color

6. Why This Implementation Stands Out Compared to class or lab work
Custom Color Mapping: This shader introduces LUT-based grading, a professional technique not typically covered in basic lessons.
Dynamic Intensity Blending: The _Contribution property allows seamless control over the effect's intensity, enabling interactive or event-driven grading.
High Performance: Unlike pixel-by-pixel color manipulation, this LUT-based approach minimizes performance overhead, allowing for real-time use in gameplay.
Scene-Specific Customization: Easily swap LUTs for different levels, events, or environments, providing unmatched flexibility for enhancing the atmosphere.
