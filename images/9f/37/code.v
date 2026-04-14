module top_module(clk, s7_exmem, rf_wen_exmem, 
mem2reg_exmem, rf_waddr_exmem, aluout_exmem, extended_exmem, 
rf_wen_memwb, mem2reg_memwb, rf_waddr_memwb, aluout_memwb, extended_memwb, s7_memwb,
nop_lw_exmem, nop_lw_memwb,
pc_added_exmem, pc_added_memwb,
jal_exmem, jal_memwb
);input clk;
    input s7_exmem;
    input rf_wen_exmem;
    input mem2reg_exmem;
    input [3:0] rf_waddr_exmem;
    input [15:0] aluout_exmem;
    input [15:0] extended_exmem;
    input [15:0] pc_added_exmem;
    input jal_exmem;
    
    input nop_lw_exmem;
    
    output nop_lw_memwb;
    
    output rf_wen_memwb;
    output mem2reg_memwb;
    output s7_memwb;
    output [3:0] rf_waddr_memwb;
    output [15:0] aluout_memwb;
    output [15:0] extended_memwb;
    output [15:0] pc_added_memwb;
    output jal_memwb;
    
    reg rf_wen_memwb_temp;
    reg mem2reg_memwb_temp;
    reg [3:0] rf_waddr_memwb_temp;
    reg [15:0] aluout_memwb_temp;
    reg [15:0] extended_memwb_temp;
    reg s7_memwb_temp;
    reg nop_lw_temp;
    reg [15:0] pc_added_temp;
    reg jal_temp;
    
    
    always @ (posedge clk)
        begin
        rf_wen_memwb_temp <= rf_wen_exmem;
        mem2reg_memwb_temp <= mem2reg_exmem;
        rf_waddr_memwb_temp <= rf_waddr_exmem;
        aluout_memwb_temp <= aluout_exmem;
        s7_memwb_temp <= s7_exmem;
        extended_memwb_temp <= extended_exmem;
        nop_lw_temp <= nop_lw_exmem;
        
        pc_added_temp <= pc_added_exmem;
        jal_temp <= jal_exmem;
        end
    
    assign rf_wen_memwb = rf_wen_memwb_temp;
    assign mem2reg_memwb = mem2reg_memwb_temp;
    assign rf_waddr_memwb = rf_waddr_memwb_temp;
    assign aluout_memwb = aluout_memwb_temp;
    assign s7_memwb = s7_memwb_temp;
    assign extended_memwb = extended_memwb_temp;
    assign nop_lw_memwb = nop_lw_temp;
    assign pc_added_memwb = pc_added_temp;
    
    assign jal_memwb = jal_temp;
         

endmodule