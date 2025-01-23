#version 300 es

/* Assignment 5: Artistic Rendering
 * CS 4388/ CS 5388, Fall 2024, Texas State University
 * Instructor: Isayas Berhe Adhanom <isayas@txstate.edu>
 * Assignment originaly developed by Daniel Keefe, implemented for GopherGFX by Evan Suma Rosenberg and revised by Isayas Berhe Adhanom
 * PUBLIC DISTRIBUTION OF SOURCE CODE OUTSIDE OF CS 4388/ CS 5388 IS PROHIBITED
 */ 

precision mediump float;

const int MAX_LIGHTS = 8;

uniform mat4 modelMatrix;
uniform mat4 normalMatrix;
uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;

uniform vec3 eyePositionWorld;

#define POINT_LIGHT 0
#define DIRECTIONAL_LIGHT 1

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

// per-vertex data
in vec3 position;
in vec3 normal;
in vec4 color;
in vec2 texCoord;

// data we want to send to the rasterizer and eventually the fragment shader
out vec4 vertColor;
out vec2 uv;

void main() 
{
    //position in world space  
    vec3 worldPosition = (modelMatrix * vec4(position, 1)).xyz;

    //normal in world space
    vec3 worldNormal = normalize((normalMatrix * vec4(normal, 0)).xyz);

    // Lighting calculations
    vec3 illumination = vec3(0,0,0);

    for(int i=0; i< numLights; i++){
        //ambient component
        illumination += kAmbient * ambientIntensities[i];

        //light direction vector - dont forget to normalize!
        vec3 l; 
        if(lightTypes[i] == POINT_LIGHT)
            l = normalize(lightPositionsWorld[i] - worldPosition);
        else
            l = normalize(lightPositionsWorld[i]);

        //diffuse component
        float diffuseComponent = max(dot(worldNormal, l), 0.0);
        illumination += kDiffuse * diffuseIntensities[i] * diffuseComponent;

        //Compute the vector from the vertex position to the eye
        vec3 e = normalize(eyePositionWorld - worldPosition);

        //Compute the halfway vector for the Blinn-Phong reflection model
        vec3 h =  normalize(l + e);

        //Specular component
        float specularComponent = pow(max(dot(h, worldNormal), 0.0), shininess);
        illumination += kSpecular * specularIntensities[i] * specularComponent;


    }
    vertColor = color;
    vertColor.rgb *= illumination;

    //output the texture coordinates to the fragment shader
    uv = texCoord.xy;

    gl_Position = projectionMatrix * viewMatrix * vec4(worldPosition, 1);
    
    
    
    
    
    
    //gl_Position = vec4(0, 0, 0, 1);
}
