module mux2to1 (
    input wire sel,
    input wire [1:0] d,
    output wire y
);

    assign y = sel ? d[1] : d[0];

endmodule