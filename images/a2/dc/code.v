module top_module(out,in);input [1:0] in; 
  output reg [1:0] out; 
  always @* begin 
  case (in[1:0]) 
  2'd0, 2'd1, 2'd2, 2'd3: begin 
  out = in; 
  end 
  endcase 
  end 
 endmodule