module mux_2to1 (
    input wire [1:0] I,
    input wire S,
    output wire Y
    );

assign Y = (I[0] & ~S) | (I[1] & S);

endmodule