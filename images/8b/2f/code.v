module top_module(
  input clk,
  input reset,
  input [7:0] data,
  input edge_detect,
  input a,
  input b,
  input sel_b1,
  input sel_b2,
  output reg [15:0] led_out
);reg [7:0] pattern1;
  reg [7:0] pattern2;
  reg [1:0] sel_pattern;
  reg edge_detected;

  always @(posedge clk) begin
    if (reset) begin
      pattern1 <= 8'b00000000;
      pattern2 <= 8'b00000000;
      sel_pattern <= 2'b00;
      edge_detected <= 1'b0;
    end else begin
      if (edge_detect) begin
        edge_detected <= 1'b1;
        sel_pattern <= 2'b01;
        pattern2 <= data;
      end else begin
        edge_detected <= 1'b0;
        sel_pattern <= 2'b00;
        pattern1 <= data;
      end
    end
  end

  always @(posedge clk) begin
    case ({sel_b2, sel_b1})
      2'b00: led_out <= {pattern1, 8'b00000000};
      2'b01: led_out <= {pattern2, 8'b00000000};
      2'b10: led_out <= {8'b00000000, a};
      2'b11: led_out <= {8'b00000000, b};
    endcase
  end

endmodule