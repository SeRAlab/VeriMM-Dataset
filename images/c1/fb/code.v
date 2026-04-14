module clock_divider (
  input clk_in, 
  input rst,
  output reg clk_out
);

parameter div_factor = 2;

always @(posedge clk_in, posedge rst) begin
  if (rst) begin
    clk_out <= 0;
  end else begin
    clk_out <= ~clk_out; // toggle the output clock signal
  end
end

assign clk_out = clk_out & ((div_factor/2)-1'b1); // determine the frequency of the output clock signal

endmodule