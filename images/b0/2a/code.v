module top_module(clk, rst, we, incr, wr, rd);parameter width = 'd16; 
  parameter add_width = 'd13; 
  input wire clk , rst ; 
  input wire we , incr ; 
  input wire [width-1:0] wr ; 
  output wire [add_width-1:0] rd ; 
  reg [width-1:0] mem ; 
  assign rd [add_width-1:0] = mem [add_width-1:0]; 
  always@(posedge clk) begin 
  if(rst) mem [width-1:0] <= {width{1'b0}}; 
  else if(we) mem [width-1:0] <= wr [width-1:0]; 
  else if(incr) mem [width-1:0] <= mem [width-1:0] + 1'b1; 
  end 
 endmodule