module mux8to1 (
    input wire [7:0] I,  // 8 input lines
    input wire [2:0] S,  // 3 selection lines
    output wire Y        // output line
);
    assign Y = I[S]; // Selecting the input based on the selection lines
endmodule