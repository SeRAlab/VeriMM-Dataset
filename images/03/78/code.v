module mux16to1 (  
    input wire [15:0] D,  // 16 data inputs  
    input wire [3:0] S,   // 4 selection inputs  
    output wire Y         // output  
);  
    assign Y = D[S];      // Select the data input based on selection lines  
endmodule