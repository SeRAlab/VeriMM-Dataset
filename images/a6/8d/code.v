module top_module(
  seq_dst, branch_dst, jump_dst, jr_dst,
  branch, jump, jr,
  PC_dst
    );input [31:0] seq_dst, branch_dst, jump_dst, jr_dst;
    input branch, jump, jr;
    output [31:0] PC_dst;

    wire [31:0] a, b;
    assign a = (branch) ? branch_dst : seq_dst;
    assign b = (jump) ? jump_dst : a;
    assign PC_dst = (jr) ? jr_dst : b;
endmodule