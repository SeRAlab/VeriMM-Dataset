module top_module(
    input [2:0] cs,
    input Extra,
    input Loop,
    output [2:0] ns,
    output fetch,
    output exec1,
    output exec2
);assign ns[2] = 0;
assign ns[1] = ~cs[2]&~cs[1]&cs[0]&Extra&~Loop;
assign ns[0] = ~cs[2]&~cs[1]&~cs[0] | ~cs[2]&~cs[1]&cs[0]&Loop;
assign fetch = ~cs[2]&~cs[1]&~cs[0];
assign exec1 = ~cs[2]&~cs[1]&cs[0];
assign exec2 = ~cs[2]&cs[1]&~cs[0];

endmodule