#version 300 es

/* Assignment 5: Artistic Rendering
 * CS 4388/ CS 5388, Fall 2024, Texas State University
 * Instructor: Isayas Berhe Adhanom <isayas@txstate.edu>
 * Assignment originaly developed by Daniel Keefe, implemented for GopherGFX by Evan Suma Rosenberg and revised by Isayas Berhe Adhanom
 * PUBLIC DISTRIBUTION OF SOURCE CODE OUTSIDE OF CS 4388/ CS 5388 IS PROHIBITED
 */ 

precision mediump float;

// material properties: coeff. of reflection for the material
uniform mat4 modelMatrix;
uniform mat4 normalMatrix;
uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;

// per-vertex data
in vec3 position;
in vec3 normal;
in vec4 color;
in vec2 texCoord;

// data we want to send to the rasterizer and eventually the fragment shader
out vec3 vertPositionWorld;
out vec3 vertNormalWorld;
out vec4 vertColor;
out vec2 uv;

void main() 
{
    //position in world space  
    vertPositionWorld = (modelMatrix * vec4(position, 1)).xyz;

    //normal in world space
    vertNormalWorld = normalize((normalMatrix * vec4(normal, 0)).xyz);

    //output the vertex color to the fragment shader
    vertColor = color;

    //output the texture coordinates to the fragment shader
    uv = texCoord.xy;

    // compute the 2D screen coordinate position
    gl_Position = projectionMatrix * viewMatrix * vec4(vertPositionWorld, 1);
    
    
    //gl_Position = vec4(0, 0, 0, 1);
}
