module top_module(q, d,write_address, read_address,we, rde, clk, clk_ena);parameter WIDTH = 8; 
  parameter LEN_ADDR = 8; 
  parameter DEPTH = 2**LEN_ADDR; 
  output reg [WIDTH-1:0] q; 
  input [WIDTH-1:0] d; 
  input [LEN_ADDR-1:0] write_address, read_address; 
  input we, rde, clk, clk_ena; 
  reg [WIDTH-1:0] mem [DEPTH-1:0]; 
  always @ (posedge clk) begin 
  if (we) 
  mem[write_address] <= d; 
  if(rde) 
  q <= mem[read_address]; 
  end 
 endmodule