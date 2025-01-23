#version 300 es

/* Assignment 5: Artistic Rendering
 * CS 4388/ CS 5388, Fall 2024, Texas State University
 * Instructor: Isayas Berhe Adhanom <isayas@txstate.edu>
 * Assignment originaly developed by Daniel Keefe, implemented for GopherGFX by Evan Suma Rosenberg and revised by Isayas Berhe Adhanom
 * PUBLIC DISTRIBUTION OF SOURCE CODE OUTSIDE OF CS 4388/ CS 5388 IS PROHIBITED
 */ 

precision mediump float;

// texture data
uniform int useTexture;
uniform sampler2D textureImage;

// data passed in from the vertex shader
in vec4 vertColor;
in vec2 uv;

// fragment shaders can only output a single color
out vec4 fragColor;

void main() 
{
    fragColor = vertColor;

    if(useTexture != 0)
    {
        fragColor *= texture(textureImage, uv);
    }
    
    
    //fragColor = vec4(0, 0, 0, 1);
}
