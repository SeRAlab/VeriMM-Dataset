module top_module(
  input clk_in,
  input resetn,
  output reg clk_out1,
  output reg clk_out2,
  output reg clk_out3,
  output reg clk_out4,
  output reg locked
);reg [1:0] counter1 = 2'b0;
  reg [2:0] counter2 = 3'b0;
  reg [3:0] counter3 = 4'b0;
  reg [4:0] counter4 = 5'b0;
  reg [3:0] stable_counter = 4'b0;

  always @(posedge clk_in or negedge resetn) begin
    if (!resetn) begin
      counter1 <= 2'b0;
      counter2 <= 3'b0;
      counter3 <= 4'b0;
      counter4 <= 5'b0;
      stable_counter <= 4'b0;
      clk_out1 <= 1'b0;
      clk_out2 <= 1'b0;
      clk_out3 <= 1'b0;
      clk_out4 <= 1'b0;
      locked <= 1'b0;
    end else begin
      counter1 <= counter1 + 1;
      counter2 <= counter2 + 1;
      counter3 <= counter3 + 1;
      counter4 <= counter4 + 1;
      stable_counter <= stable_counter + 1;
      if (counter1 == 2'b0) begin
        clk_out1 <= ~clk_out1;
      end
      if (counter2 == 3'b0) begin
        clk_out2 <= ~clk_out2;
      end
      if (counter3 == 4'b0) begin
        clk_out3 <= ~clk_out3;
      end
      if (counter4 == 5'b0) begin
        clk_out4 <= ~clk_out4;
      end
      if (stable_counter == 4'b10) begin
        locked <= 1'b1;
      end
    end
  end

endmodule