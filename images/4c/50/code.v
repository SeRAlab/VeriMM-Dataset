module top_module(WriteData,res_hi,res_lo,md_signal,md_control,WriteData_final);input [31:0] WriteData,res_hi,res_lo;
    input md_signal;
    input [2:0] md_control;
    output [31:0] WriteData_final;

    assign WriteData_final = md_signal?((md_control[2]&md_control[1]&~md_control[0])?res_hi:res_lo):WriteData;endmodule