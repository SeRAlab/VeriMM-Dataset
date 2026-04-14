module top_module(
  input clk,
  input rst,
  input ctrl,
  output reg clk_out
);parameter max_div = 16;
parameter min_div = 1;

reg [3:0] div_factor = 4'b0001; // default division factor is 1

always @(posedge clk or posedge rst) begin
  if (rst) begin
    div_factor <= 4'b0001; // reset division factor to default
  end else begin
    case (ctrl)
      2'b00: div_factor <= 4'b0001; // division factor is 1
      2'b01: div_factor <= 4'b0010; // division factor is 2
      2'b10: div_factor <= 4'b0100; // division factor is 4
      2'b11: div_factor <= 4'b1000; // division factor is 8
      default: div_factor <= 4'b0001; // default division factor is 1
    endcase
  end
end

reg [3:0] counter = 4'b0000;

always @(posedge clk) begin
  if (counter == div_factor - 1) begin
    counter <= 4'b0000;
    clk_out <= ~clk_out; // generate clock signal
  end else begin
    counter <= counter + 1;
  end
end

endmodule