module top_module(
    input [59:0] dataa,
    input [49:0] datab,
    output signed [109:0] result
);wire signed [109:0] sub_wire0;
    assign result = sub_wire0;

    assign sub_wire0 = dataa * datab;

endmodule