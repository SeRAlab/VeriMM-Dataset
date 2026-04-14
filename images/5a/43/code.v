module top_module(
  input clk,
  input rst,
  input [7:0] bin,
  output reg [2:0] dec
);reg [7:0] abs_bin;
reg sign;

always @(posedge clk, posedge rst) begin
  if (rst) begin
    abs_bin <= 8'b0;
    sign <= 1'b0;
    dec <= 3'b000;
  end else begin
    abs_bin <= (bin[7] == 1) ? ~bin + 1 : bin;
    sign <= bin[7];
    dec <= (abs_bin >= 8'hA0) ? 3'b100 :
           (abs_bin >= 8'h64) ? 3'b010 :
           (abs_bin >= 8'h0A) ? 3'b001 :
                                3'b000;
    if (dec[2] == 1) begin
      abs_bin <= abs_bin - 8'hA0;
    end else if (dec[1] == 1) begin
      abs_bin <= abs_bin - 8'h64;
    end else if (dec[0] == 1) begin
      abs_bin <= abs_bin - 8'h0A;
    end
    dec <= (sign == 1) ? -dec : dec;
  end
end

endmodule