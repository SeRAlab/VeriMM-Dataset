module top_module(
  input      [7:0] data,       
  input      [2:0] read_addr,  
  input      [2:0] write_addr, 
  input            we,         
  input clk,
  output reg [7:0] q           
);reg [7:0] ram [7:0]; 
    
  always @(posedge clk) begin 
    if (we) begin 
      ram[write_addr] <= data;
    end
  end
    
  always @(posedge clk) 
  begin 
    q <= ram[read_addr];
  end

endmodule