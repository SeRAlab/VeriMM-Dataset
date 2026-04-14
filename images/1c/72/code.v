module mux16to1 (
    input wire [15:0] I,  // 16 input lines
    input wire [3:0] S,   // 4 select lines
    output wire Y         // output
);
    assign Y = I[S];      // Select the output based on select lines
endmodule