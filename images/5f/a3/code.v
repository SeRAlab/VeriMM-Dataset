module mux4bit2to1 (
    input wire sel,
    input wire [7:0] d,
    output wire [3:0] y
);

    assign y = sel ? d[7:4] : d[3:0];

endmodule