module top_module(
  input [(1 - 1):0] ip,
  output [(1 - 1):0] op,
  input clk,
  input ce,
  input clr
);reg op_mem_22_20;
  wire ip_1_26;
  wire op_mem_22_20_back;
  wire op_mem_22_20_push_front_pop_back_en;
  wire internal_ip_12_1_bitnot;
  
  assign ip_1_26 = ip;
  assign op_mem_22_20_back = op_mem_22_20;
  
  always @(posedge clk) begin
    if (clr) begin
      op_mem_22_20 <= 1'b0;
    end else if (ce && op_mem_22_20_push_front_pop_back_en) begin
      op_mem_22_20 <= 1'b1;
    end
  end
  
  assign internal_ip_12_1_bitnot = ~ip_1_26;
  assign op_mem_22_20_push_front_pop_back_en = 1'b0;
  assign op = internal_ip_12_1_bitnot;
endmodule