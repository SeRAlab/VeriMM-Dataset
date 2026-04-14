module mux2to1_32(
    input wire sel,
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] o
);

always @(*)
    if(sel == 0)
        o <= a;
    else
        o <= b;

endmodule