module mux16to1 (
    input [15:0] I,  // 16 input lines
    input [3:0] S,   // 4 selection lines
    output Y         // Output line
);
    assign Y = I[S]; // Select the output based on selection lines
endmodule