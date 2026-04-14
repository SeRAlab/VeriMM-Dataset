module mux8to1 (
    input wire [7:0] data,
    input wire [2:0] sel,
    output wire out
);
    assign out = data[sel];
endmodule