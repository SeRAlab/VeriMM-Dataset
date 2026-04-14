module mux2to1 #(
    parameter DATAWIDTH = 8
) (
    input wire sel,
    input wire [DATAWIDTH-1:0] in0,
    input wire [DATAWIDTH-1:0] in1,
    output wire [DATAWIDTH-1:0] out
);

    assign out = sel ? in1 : in0;

endmodule