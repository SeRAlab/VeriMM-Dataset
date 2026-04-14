module top_module(
  input rst,
  input en,
  input [15:0] freq,
  input [15:0] duty,
  output reg clk
);reg [31:0] counter;
  reg [15:0] threshold;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      clk <= 1'b0;
      counter <= 0;
    end else if (en) begin
      if (counter == threshold) begin
        clk <= ~clk;
        counter <= 0;
      end else begin
        counter <= counter + 1;
      end
    end
  end

  always @(*) begin
    threshold = (50000000 / (2 * freq)) - 1;
  end

  always @(*) begin
    clk = (counter < (threshold * (duty / 65536))) ? 1'b1 : 1'b0;
  end

endmodule