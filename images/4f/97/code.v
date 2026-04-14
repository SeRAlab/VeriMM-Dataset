module top_module(
  clk,
  rst,
  inc,
  index
);input clk;
  input rst;
  input inc;
  
  output[2:0] index;

  reg[2:0] count;
  reg[2:0] next;
  always @* begin
    if (rst)
    	next = 3'b000;
    else if (count == 3'b111)
    	next = count;
    else if (inc)
      next = count + 3'b001;
  	else
      next = count;
  end
  
  
  always @(posedge clk) begin
    count <= next;
  end

  assign index = count;
endmodule