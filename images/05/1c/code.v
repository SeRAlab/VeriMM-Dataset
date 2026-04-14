module mux2to1 (
    input wire [4:0] a,
    input wire [4:0] b,
    input wire sel,
    output wire [4:0] y
);
    assign y = sel ? b : a;
endmodule