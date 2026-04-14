module top_module(
    output out,
    input addr0, addr1,
    input in0, in1, in2, in3
);wire[3:0] inputs = {in3, in2, in1, in0};
    wire[1:0] address = {addr1, addr0};
    assign out = inputs[address];endmodule