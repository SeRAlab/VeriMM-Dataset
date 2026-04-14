module top_module(
  input clk,
  input rst,
  input ctrl,
  input [n-1:0] count_in,
  output [n-1:0] count_out,
  output zero_flag
);parameter n = 4; // number of bits in the count value
parameter mod_value = 10; // count value at which the counter should reset to zero

reg [n-1:0] count_reg;
wire count_up;
wire count_down;
wire count_reset;

assign count_up = (ctrl == 1'b1) ? 1'b1 : 1'b0;
assign count_down = (ctrl == 1'b0) ? 1'b1 : 1'b0;
assign count_reset = (count_reg == mod_value) ? 1'b1 : 1'b0;

always @(posedge clk or posedge rst) begin
  if (rst == 1'b1) begin
    count_reg <= 0;
  end else begin
    if (count_reset == 1'b1) begin
      count_reg <= 0;
    end else begin
      if (count_up == 1'b1) begin
        count_reg <= count_reg + 1;
      end else if (count_down == 1'b1) begin
        count_reg <= count_reg - 1;
      end
    end
  end
end

assign count_out = count_reg;
assign zero_flag = (count_reg == 0) ? 1'b1 : 1'b0;

endmodule