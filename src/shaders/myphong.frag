#version 300 es

/* Assignment 5: Artistic Rendering
 * CS 4388/ CS 5388, Fall 2024, Texas State University
 * Instructor: Isayas Berhe Adhanom <isayas@txstate.edu>
 * Assignment originaly developed by Daniel Keefe, implemented for GopherGFX by Evan Suma Rosenberg and revised by Isayas Berhe Adhanom
 * PUBLIC DISTRIBUTION OF SOURCE CODE OUTSIDE OF CS 4388/ CS 5388 IS PROHIBITED
 */ 

precision mediump float;

#define POINT_LIGHT 0
#define DIRECTIONAL_LIGHT 1

const int MAX_LIGHTS = 8;

// position of the camera in world coordinates
uniform vec3 eyePositionWorld;

// properties of the lights in the scene
uniform int numLights;
uniform int lightTypes[MAX_LIGHTS];
uniform vec3 lightPositionsWorld[MAX_LIGHTS];
uniform vec3 ambientIntensities[MAX_LIGHTS];
uniform vec3 diffuseIntensities[MAX_LIGHTS];
uniform vec3 specularIntensities[MAX_LIGHTS];

// material properties (coefficents of reflection)
uniform vec3 kAmbient;
uniform vec3 kDiffuse;
uniform vec3 kSpecular;
uniform float shininess;

// texture data
uniform int useTexture;
uniform sampler2D textureImage;

// data passed in from the vertex shader
in vec3 vertPositionWorld;
in vec3 vertNormalWorld;
in vec4 vertColor;
in vec2 uv;

// fragment shaders can only output a single color
out vec4 fragColor;

void main() 
{
     //Normalize the interpolated normal vector
    vec3 n = normalize(vertNormalWorld);

    // Lighting calculations
    vec3 illumination = vec3(0,0,0);

    for(int i=0; i< numLights; i++){
        //ambient component
        illumination += kAmbient * ambientIntensities[i];

        //light direction vector - dont forget to normalize!
        vec3 l; 
        if(lightTypes[i] == POINT_LIGHT)
            l = normalize(lightPositionsWorld[i] - vertPositionWorld);
        else
            l = normalize(lightPositionsWorld[i]);

        //diffuse component
        float diffuseComponent = max(dot(n, l), 0.0);
        illumination += kDiffuse * diffuseIntensities[i] * diffuseComponent;

        //Compute the vector from the vertex position to the eye
        vec3 e = normalize(eyePositionWorld - vertPositionWorld);

        //Compute the halfway vector for the Blinn-Phong reflection model
        vec3 h =  normalize(l + e);

        //Specular component
        float specularComponent = pow(max(dot(h, n), 0.0), shininess);
        illumination += kSpecular * specularIntensities[i] * specularComponent;

    }
    fragColor = vertColor;
    fragColor.rgb *= illumination;

    if(useTexture != 0)
    {
        fragColor *= texture(textureImage, uv);
    }
    
    
    
    //fragColor = vec4(0, 0, 0, 1);
}