module top_module(input [(1 - 1):0] ip,output [(1 - 1):0] op,input clk,input ce,input clr);wire ip_1_26; 
  reg op_mem_22_20[0:(1 - 1)]; 
  initial 
  begin 
  op_mem_22_20[0] = 1'b0; 
  end 
  wire op_mem_22_20_front_din; 
  wire op_mem_22_20_back; 
  wire op_mem_22_20_push_front_pop_back_en; 
  localparam [(1 - 1):0] const_value = 1'b1; 
  wire internal_ip_12_1_bitnot; 
  assign ip_1_26 = ip; 
  assign op_mem_22_20_back = op_mem_22_20[0]; 
  always @(posedge clk) 
  begin:proc_op_mem_22_20 
  integer i; 
  if (((ce == 1'b1) && (op_mem_22_20_push_front_pop_back_en == 1'b1))) 
  begin 
  op_mem_22_20[0] <= op_mem_22_20_front_din; 
  end 
  end 
  assign internal_ip_12_1_bitnot = ~ip_1_26; 
  assign op_mem_22_20_push_front_pop_back_en = 1'b0; 
  assign op = internal_ip_12_1_bitnot; 
 endmodule