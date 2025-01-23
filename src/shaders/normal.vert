#version 300 es

/* Assignment 5: Artistic Rendering
 * CS 4388/ CS 5388, Fall 2024, Texas State University
 * Instructor: Isayas Berhe Adhanom <isayas@txstate.edu>
 * Assignment originaly developed by Daniel Keefe, implemented for GopherGFX by Evan Suma Rosenberg and revised by Isayas Berhe Adhanom
 * PUBLIC DISTRIBUTION OF SOURCE CODE OUTSIDE OF CS 4388/ CS 5388 IS PROHIBITED
 */ 

precision mediump int;
precision mediump float;

const int MAX_LIGHTS = 8;

uniform int numLights;
uniform vec3 lightPositions[MAX_LIGHTS];
uniform vec3 eyePosition;

uniform mat4 modelMatrix;
uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 normalMatrix;

in vec3 position;
in vec3 normal;
in vec3 tangent;
in vec4 color;
in vec2 texCoord;

out vec4 vertColor;
out vec2 uv;
out vec3 tangentVertPosition;
out vec3 tangentEyePosition;
out vec3 tangentLightPositions[MAX_LIGHTS];

// Normal mapping is a complex effect that will involve changing
// both the vertex and fragment shader. This implementation is
// based on the approach described below, and you are encouraged
// to read this tutorial writeup for a deeper understanding.
// https://learnopengl.com/Advanced-Lighting/Normal-Mapping

// Most of the structure of this fragment shader has been implemented,
// but you will need to complete the code that computes the normal n.

// You should complete the vertex shader first, and then move on to
// this fragment shader only after you have verified that is correct.

void main() 
{
    // Assign the vertex color and uv
    vertColor = color;
    uv = texCoord.xy; 

    // Compute the world vertex position
    vec3 worldPosition = (modelMatrix * vec4(position, 1)).xyz;   

    // TO BE ADDED
    // This line of code sets the TBN to an identity matrix.
    // You will need to replace it and compute the matrix that
    // converts vertices from world space to tangent space. 
    // When this part is completed correctly, it will produce
    // a result that looks identical to the Phong shader.
    // Then, you can move on to complete the fragment shader.
    //mat3 tbn = mat3(1.0f);


    vec3 T = normalize(vec3(normalMatrix * vec4(tangent, 0.0)));
    vec3 N = normalize(vec3(normalMatrix * vec4(normal, 0.0)));
    
    T = normalize(T - dot(T, N) * N);

    vec3 B = cross(N, T);

    mat3 tbn = transpose(mat3(T, B, N));
        
    
    // Compute the tangent space vertex and view positions
    tangentVertPosition = tbn * worldPosition;
    tangentEyePosition = tbn * eyePosition;

    // Compute the tangent space light positions
    for(int i=0; i < numLights; i++)
    {
        tangentLightPositions[i] = tbn * lightPositions[i];
    }
    
    // Compute the projected vertex position
    gl_Position = projectionMatrix * viewMatrix * vec4(worldPosition, 1);
}