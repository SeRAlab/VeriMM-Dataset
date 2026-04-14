module mux16to1(  
    input [15:0] I,     // 16-bit input  
    input [3:0] S,      // 4-bit select line  
    output Y            // Output  
);  
    assign Y = I[S];     // Select the appropriate input based on the select lines  
endmodule