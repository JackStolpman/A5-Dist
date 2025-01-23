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

uniform vec3 eyePosition;

uniform int numLights;
uniform int lightTypes[MAX_LIGHTS];
uniform vec3 lightPositions[MAX_LIGHTS];
uniform vec3 ambientIntensities[MAX_LIGHTS];
uniform vec3 diffuseIntensities[MAX_LIGHTS];
uniform vec3 specularIntensities[MAX_LIGHTS];

uniform vec3 kAmbient;
uniform vec3 kDiffuse;
uniform vec3 kSpecular;
uniform float shininess;

uniform int useTexture;
uniform sampler2D textureImage;

uniform sampler2D diffuseRamp;
uniform sampler2D specularRamp;

in vec3 vertPositionWorld;
in vec3 vertNormalWorld;
in vec4 vertColor;
in vec2 uv;

out vec4 fragColor;

// You should modify this fragment shader to implement a toon shading model
// First, you should copy and paste the code from your Phong fragment shader.
// Then, you can then modify it to use the diffuse and specular ramps. 

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
            l = normalize(lightPositions[i] - vertPositionWorld);
        else
            l = normalize(lightPositions[i]);

        //diffuse component
        float diffuseTexCoord = max(dot(n, l), 0.0) * 0.5 + 0.5;
        //float diffuseTexCoord = (diffuseComponent + 1.0) *0.5;
        vec3 diffuseComponent = texture(diffuseRamp, vec2(diffuseTexCoord, 0.5)).rgb;

        illumination += kDiffuse * diffuseIntensities[i] * diffuseComponent;

        //Compute the vector from the vertex position to the eye
        vec3 e = normalize(eyePosition - vertPositionWorld);

        //Compute the halfway vector for the Blinn-Phong reflection model
        vec3 h =  normalize(l + e);

        //Specular component
        float specularComponent = pow(max(dot(h, n), 0.0), shininess);
        
        //vec4 specularColor = texture(specularRamp, vec2(specularComponent, 0.5));
        vec3 specularColor = texture(specularRamp, vec2(specularComponent, 0.0)).rgb;
        
        illumination += kSpecular * specularIntensities[i] * specularColor;

    }
    fragColor = vertColor;
    fragColor.rgb *= illumination;

    if(useTexture != 0)
    {
        fragColor *= texture(textureImage, uv);
    }
    
    
    
    //fragColor = vec4(0, 0, 0, 1);
}