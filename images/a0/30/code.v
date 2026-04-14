module top_module(clk, rst_n, load, out, sel, word_in);input clk, rst_n, load;
  output [127:0] out;
  input [1:0] sel;
  input [32:0] word_in;

  reg [31:0]D[0:3];
  assign out = {D[3], D[2], D[1], D[0]};

  always@(posedge clk) begin
  	if(~rst_n) begin
  		{D[3], D[2], D[1], D[0]} <= 128'd0;
  	end
  	else if(load) D[sel] <= word_in;
  end

endmodule