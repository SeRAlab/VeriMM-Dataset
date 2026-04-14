module top_module(clk,we,waddr,raddr,wdata,rdata);input clk;				
  input we;					
  input [9:0] waddr;		
  input [9:0] raddr;		
  input [15:0] wdata;		
  output reg [15:0] rdata;	

  
  reg [15:0] mem [1023:0];

  always @(posedge clk) begin
    if (we)
      mem[waddr] <= wdata;
    rdata <= mem[raddr];
  end
  

endmodule