module mux8to1 (
    input [7:0] D,   // 8 data inputs
    input [2:0] S,   // 3 select lines
    output Y         // output
);
    assign Y = D[S]; // Select the output based on select lines
endmodule