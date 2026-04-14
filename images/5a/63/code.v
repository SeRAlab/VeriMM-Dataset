module top_module( input clk, rst,input if_id_write_en,input pc_write,input [1:0] pc_source,input pstop_i,output i_read_en,output [31:0] i_addr,input [31:0] i_instr_in,input [31:0] jump_addr, branch_addr,output reg [31:0] IF_ID_next_i_addr,output reg [31:0] IF_ID_instruction );reg [31:0] pc_reg, pc_next; 
  wire [31:0] next_i_addr; 
  localparam LW = 6'b100011, 
  SW = 6'b101011; 
  wire mem_op = (IF_ID_instruction[31:26] == LW) || (IF_ID_instruction[31:26] == SW); 
  assign next_i_addr = pc_reg + 4; 
  assign i_read_en = 1; 
  assign i_addr = pc_reg >> 2; 
  always @* begin 
  pc_next = pc_reg; 
  case (pc_source) 
  2'b00: pc_next = next_i_addr; 
  2'b01: pc_next = branch_addr; 
  2'b10: pc_next = jump_addr; 
  endcase 
  end 
  always @(posedge clk) begin 
  if (rst) 
  pc_reg <= 0; 
  else begin 
  if (pc_write && !(pstop_i || mem_op)) 
  pc_reg <= pc_next; 
  end 
  end 
  always @(posedge clk) begin 
  if (rst) begin 
  IF_ID_next_i_addr <= 0; 
  IF_ID_instruction <= 0; 
  end 
  else begin 
  if ( if_id_write_en) begin 
  IF_ID_next_i_addr <= next_i_addr; 
  IF_ID_instruction <= !(pstop_i || mem_op)? i_instr_in: 0; 
  end 
  end 
  end 
 endmodule