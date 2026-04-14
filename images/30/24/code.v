module mux8to1(
    input wire [7:0] d,
    input wire [2:0] sel,
    output wire y
);

assign y = d[sel];

endmodule