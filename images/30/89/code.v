module mux16to1 (  
    input [15:0] I,  
    input [3:0] S,  
    output Y  
);  
    assign Y = I[S];  
endmodule