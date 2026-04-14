module mux2to1_param #(
    parameter WIDTH = 8
)(
    input sel,
    input [WIDTH-1:0] in0,
    input [WIDTH-1:0] in1,
    output [WIDTH-1:0] out
);

assign out = sel ? in1 : in0;

endmodule