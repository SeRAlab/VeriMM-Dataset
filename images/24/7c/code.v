module mux16to1 (
    input wire [15:0] I,   // 16 input lines
    input wire [3:0] S,    // 4 selection lines
    output wire Y          // output line
);
    assign Y = I[S];       // Select Y from input based on selection lines
endmodule