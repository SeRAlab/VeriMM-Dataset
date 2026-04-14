module clock_divider (
  input clk_in, rst,
  output reg clk_out
);

parameter div_factor = 2; // divide by 2

reg [31:0] counter;

always @(posedge clk_in or posedge rst) begin
  if (rst) begin
    counter <= 0;
    clk_out <= 0;
  end else begin
    counter <= counter + 1;
    if (counter == div_factor - 1) begin
      counter <= 0;
      clk_out <= ~clk_out;
    end
  end
end

endmodule