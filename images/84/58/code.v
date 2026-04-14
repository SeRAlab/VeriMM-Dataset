module top_module(
  input clk,
  input thresh_sw,
  input count_sw,
  input [31:0] threshold,
  output reg [31:0] count,
  output reg zero,
  output reg max,
  output reg gtu,
  output reg gts,
  output reg ltu,
  output reg lts,
  output reg geu,
  output reg ges,
  output reg leu,
  output reg les
);always @(posedge clk) begin
    if (count_sw) begin
      count <= 32'd0;
    end else if (thresh_sw) begin
      count <= count - 1;
    end else begin
      count <= count + 1;
    end

    zero <= (count == 32'd0);
    max <= (count == 32'hFFFFFFFF);
    gtu <= (count > threshold);
    gts <= ($signed(count) > $signed(threshold));
    ltu <= (count < threshold);
    lts <= ($signed(count) < $signed(threshold));
    geu <= (count >= threshold);
    ges <= ($signed(count) >= $signed(threshold));
    leu <= (count <= threshold);
    les <= ($signed(count) <= $signed(threshold));
  end

endmodule