module top_module(ID_Q,ALU_OUT,res_hi,res_lo,Fwd,Y);input [31:0] ID_Q,ALU_OUT,res_hi,res_lo;
    input [2:0] Fwd;
    output [31:0] Y;
    
    function [31:0] select;
    input [31:0] ID_Q,ALU_OUT,res_hi,res_lo;
    input [1:0] Fwd;
    case(Fwd)
        3'b000: select = ID_Q;
        3'b001: select = ALU_OUT;
        3'b100: select = res_hi;
        3'b101: select = res_lo;
    endcase
    endfunction

    assign Y = select (ID_Q,ALU_OUT,res_hi,res_lo,Fwd);endmodule