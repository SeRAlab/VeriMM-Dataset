module counter(clk, rst, en, count_out);

input clk, rst, en;
output reg [3:0] count_out;

always @(posedge clk) begin
  if (rst) begin
    count_out <= 4'b0000;
  end
  else if (en) begin
    count_out <= count_out + 1;
  end
end

endmodule