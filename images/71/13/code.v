module top_module(
    input [5:0] op,
    input [4:0] m,
    output eret,
    output mfc0,
    output mtc0
    );wire op5, op4,op3,op2,op1,op0;
    wire m4,m3,m2,m1,m0;
    assign  op5 = op[5],
            op4 = op[4],
            op3 = op[3],
            op2 = op[2],
            op1 = op[1],
            op0 = op[0];
    assign  m4 = m[4],
            m3 = m[3],
            m2 = m[2],
            m1 = m[1],
            m0 = m[0];
    assign eret = ~op5  & op4 & ~op3 & ~op2 & ~op1 & ~op0 & m4 & ~m3 & ~m2 &~ m1 & ~m0;
    assign mfc0 = ~op5 & op4 & ~op3 & ~op2 & ~op1 & ~op0 & ~m4 & ~m3 & ~m2 & ~m1 & ~m0;
    assign mtc0 = ~op5 & op4 & ~op3 & ~op2 & ~op1 & ~op0 & ~m4 & ~m3 & m2 & ~m1 & ~m0;
endmodule