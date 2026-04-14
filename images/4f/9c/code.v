module top_module(input [(10 - 1):0] a,input [(10 - 1):0] b,output [(1 - 1):0] op,input clk,input ce,input clr);wire [(10 - 1):0] a_1_31; 
  wire [(10 - 1):0] b_1_34; 
  reg op_mem_32_22[0:(1 - 1)]; 
  initial 
  begin 
  op_mem_32_22[0] = 1'b0; 
  end 
  wire op_mem_32_22_front_din; 
  wire op_mem_32_22_back; 
  wire op_mem_32_22_push_front_pop_back_en; 
  localparam [(1 - 1):0] const_value = 1'b1; 
  wire result_12_3_rel; 
  assign a_1_31 = a; 
  assign b_1_34 = b; 
  assign op_mem_32_22_back = op_mem_32_22[0]; 
  always @(posedge clk) 
  begin:proc_op_mem_32_22 
  integer i; 
  if (((ce == 1'b1) && (op_mem_32_22_push_front_pop_back_en == 1'b1))) 
  begin 
  op_mem_32_22[0] <= op_mem_32_22_front_din; 
  end 
  end 
  assign result_12_3_rel = a_1_31 == b_1_34; 
  assign op_mem_32_22_front_din = result_12_3_rel; 
  assign op_mem_32_22_push_front_pop_back_en = 1'b1; 
  assign op = op_mem_32_22_back; 
 endmodule