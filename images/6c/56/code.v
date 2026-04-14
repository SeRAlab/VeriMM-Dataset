module top_module(input clk,input [4:0] read_addr_a,input [4:0] read_addr_b,input [4:0] write_addr,input [31:0] write_data,input we,output [31:0] read_data_a,output [31:0] read_data_b);reg [31:0] registers [1:31]; 
  always @(posedge clk) begin 
  if (write_addr != 0) 
  registers[write_addr] <= (we) ? write_data : registers[write_addr]; 
  end 
  assign read_data_a = (read_addr_a == 5'b0) ? 32'h0000_0000 : registers[read_addr_a]; 
  assign read_data_b = (read_addr_b == 5'b0) ? 32'h0000_0000 : registers[read_addr_b]; 
 endmodule