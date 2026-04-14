module top_module(
    output out0, out1, out2, out3,
    input addr0, addr1,
    input enable
);assign {out3,out2,out1,out0}=enable<<{addr1,addr0};endmodule