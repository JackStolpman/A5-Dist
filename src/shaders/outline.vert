#version 300 es

/* Assignment 5: Artistic Rendering
 * CS 4388/ CS 5388, Fall 2024, Texas State University
 * Instructor: Isayas Berhe Adhanom <isayas@txstate.edu>
 * Assignment originaly developed by Daniel Keefe, implemented for GopherGFX by Evan Suma Rosenberg and revised by Isayas Berhe Adhanom
 * PUBLIC DISTRIBUTION OF SOURCE CODE OUTSIDE OF CS 4388/ CS 5388 IS PROHIBITED
 */ 


precision mediump float;

uniform mat4 modelMatrix;
uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 normalMatrix;
uniform float thickness;

in vec3 position;
in vec3 normal;

// You should start by coping and pasting the code from your Phong vertex shader.
// You will then need to modify it to displace each vertex by the outline thickness,
// making the drawn object slightly larger than the original object.
// Note that this shader only needs to calculate gl_Position and does not need to
// pass any other output variables to the fragment shader.

void main() 
{
    // First, you will need compute both the position and normal in world space,
    // then convert them into view space.

    // Next, you should set the z-component of the view space normal to zero
    // and then normalize it. This represents the direction outward from the
    // vertex in XY coordinates relative to the camera.
    
    // The view space vertex position should then be translated in this direction
    // by correct distance, which is the thickness of the silhouette online.

    // Finally, you should project this position into screen coordinates and
    // assign it to the gl_Position variable, which will be passed to the 
    // fragment shader.

    //position in world space  
    vec3 vertPositionWorld = (modelMatrix * vec4(position, 1)).xyz;

    //normal in world space
    vec3 vertNormalWorld = normalize((normalMatrix * vec4(normal, 0)).xyz);

    //position in view space
    vec4 vertPositionView = viewMatrix * vec4(vertPositionWorld, 1);

    //normal in view space
    vec4 vertNormalView = normalize(viewMatrix * vec4(vertNormalWorld, 0));
    


    vertNormalView.z = 0.0;
    vertNormalView = normalize(vertNormalView) * thickness;

    vertPositionView.x = vertNormalView.x + vertPositionView.x;
    vertPositionView.y = vertNormalView.y + vertPositionView.y;

    gl_Position = projectionMatrix * vertPositionView;

    //output the vertex color to the fragment shader
    //vertColor = color;

    //output the texture coordinates to the fragment shader
    //uv = texCoord.xy;

    // compute the 2D screen coordinate position
    //gl_Position = projectionMatrix * viewMatrix * vec4(vertPositionWorld, 1);
    




    //gl_Position = vec4(0, 0, 0, 1);
}