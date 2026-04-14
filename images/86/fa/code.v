module top_module(w_bus_data_inout, w_bus_addr, w_write_enable, w_reset, w_clock);inout [7:0] w_bus_data_inout; 
  input [7:0] w_bus_addr; 
  input w_write_enable, w_reset, w_clock; 
  reg [7:0] r_data_mem [0:255]; 
  integer i; 
  assign w_bus_data_inout = (w_write_enable) ? 8'bzzzzzzzz : r_data_mem[w_bus_addr]; 
  always @ (negedge w_clock) begin 
  if (w_write_enable) r_data_mem[w_bus_addr] <= w_bus_data_inout; 
  if (w_reset) for (i = 0; i < 256; i = i + 1) r_data_mem[i] <= 8'b00000000; 
  end 
 endmodule