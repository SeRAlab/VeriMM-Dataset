module top_module(
    input               clk,        
    input               rst,        
    input       [31:0]  mem_gpr_wd, 
    input       [4:0]   mem_gpr_wa, 
    input               mem_gpr_we, 
    input               mem_flush,  
    input               mem_stall,  
    input               wb_stall,   
    output  reg [31:0]  wb_gpr_wd,  
    output  reg [4:0]   wb_gpr_wa,  
    output  reg         wb_gpr_we   
    );always @(posedge clk) begin
        wb_gpr_wd <= (rst) ? 31'b0 : ((wb_stall) ? wb_gpr_wd                                  : mem_gpr_wd);
        wb_gpr_wa <= (rst) ? 5'b0  : ((wb_stall) ? wb_gpr_wa :((mem_stall | mem_flush) ? 5'b0 : mem_gpr_wa));
        wb_gpr_we <= (rst) ? 1'b0  : ((wb_stall) ? wb_gpr_we :((mem_stall | mem_flush) ? 1'b0 : mem_gpr_we));
    end
endmodule