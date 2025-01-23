#version 300 es

/* Assignment 5: Artistic Rendering
 * CS 4388/ CS 5388, Fall 2024, Texas State University
 * Instructor: Isayas Berhe Adhanom <isayas@txstate.edu>
 * Assignment originaly developed by Daniel Keefe, implemented for GopherGFX by Evan Suma Rosenberg and revised by Isayas Berhe Adhanom
 * PUBLIC DISTRIBUTION OF SOURCE CODE OUTSIDE OF CS 4388/ CS 5388 IS PROHIBITED
 */ 

precision mediump float;

uniform vec4 materialColor;

out vec4 fragColor;

// This shader colors each fragment using the material color
// without considering lighting. You do not need to modify it.

void main() 
{
    fragColor = materialColor;
}