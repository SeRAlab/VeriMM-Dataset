module top_module(
    input               clk,            
    input               rst,            
    input       [31:0]  if_instruction, 
    input       [31:0]  if_pc_current,  
    input       [31:0]  if_pc_add4,     
    input               if_stall,       
    input               if_flush,       
    input               id_stall,       
    input               if_is_ds,       
    output  reg [31:0]  id_instruction, 
    output  reg [31:0]  id_pc_current,  
    output  reg [31:0]  id_pc_add4,     
    
    output  reg         id_is_flushed   
    );always @(posedge clk) begin
        id_instruction <= (rst) ? 32'b0 : ((id_stall)             ? id_instruction : ((if_stall | if_flush| if_is_ds ) ? 32'b0 : if_instruction));
        id_pc_current  <= (rst) ? 32'b0 : ((id_stall | if_is_ds ) ? id_pc_current                                              : if_pc_current);
        id_pc_add4     <= (rst) ? 32'b0 : ((id_stall)             ? id_pc_add4     : ((if_stall | if_flush| if_is_ds ) ? 32'b0 : if_pc_add4));
        
        id_is_flushed  <= (rst) ? 1'b0  : ((id_stall)             ? id_is_flushed                                              : if_flush);
    end
endmodule