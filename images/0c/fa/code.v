module four_input_nor (  
    input wire a,  
    input wire b,  
    input wire c,  
    input wire d,  
    output wire y  
);  
    wire n1, n2, n3;  

    // First level: NOR gates  
    nor (n1, a, b);  
    nor (n2, c, d);  

    // Second level: NOR gate  
    nor (y, n1, n2);  
endmodule