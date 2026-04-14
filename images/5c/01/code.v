module clock_divider (
  input clk_in,
  output reg clk_out);
  
  reg [31:0] count;
  
  always @(posedge clk_in) begin
    count <= count + 1;
    clk_out <= (count == 0) ? ~clk_out : clk_out;
  end
endmodule