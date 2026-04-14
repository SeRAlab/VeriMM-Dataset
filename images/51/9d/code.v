module top_module(
    output out0, out1, out2, out3,
    input address0, address1,
    input enable
);assign {out3,out2,out1,out0}=enable<<{address1,address0};endmodule