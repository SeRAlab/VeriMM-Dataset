module top_module(
    input [3:0] brnch_pc_sel_from_bhndlr,
    input update_bpred,
    input loop_start,
    input [15:0] pc,
    input [15:0] pc_plus1,
    input [15:0] pc_plus2,
    input [15:0] pc_plus3,
    output [1:0] pred_to_pcsel
   
    );wire [1:0] numbrnch;
assign numbrnch=brnch_pc_sel_from_bhndlr[0]+brnch_pc_sel_from_bhndlr[1]+brnch_pc_sel_from_bhndlr[2]+brnch_pc_sel_from_bhndlr[3];
assign pred_to_pcsel=(update_bpred)?((loop_start)?2'b11:((numbrnch==1)?2'b10:2'b11)):2'b00;


















endmodule