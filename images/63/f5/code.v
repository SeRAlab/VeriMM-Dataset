module top_module(i_op1, i_op2, o_result);input [31:0] i_op1, i_op2;
output [31:0] o_result;

    assign o_result = i_op1 + i_op2;
    
endmodule