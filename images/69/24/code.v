module top_module(
    output reg clk_out,
    input clk_in);reg [31:0] counter= 32'd0;
parameter DIVISOR = 32'd2;

always @(posedge clk_in)
begin
 counter <= counter + 32'd1;
 if(counter>=(DIVISOR-1))
  counter <= 32'd0;

 clk_out <= (counter<DIVISOR/2)?1'b1:1'b0;

end 

endmodule