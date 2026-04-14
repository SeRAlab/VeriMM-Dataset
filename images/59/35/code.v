module top_module(clk, rst, s0, s1, in0, in1, in2, in3, out);// Parameter Definitions
  parameter width = 8;

  // Inputs
  input clk, rst, s0, s1;
  input [width-1:0] in0, in1, in2, in3;

  // Outputs
  output reg [width-1:0] out;

  // Internal
  reg [1:0] sel;

  // Reset Logic
  always @(posedge clk) begin
    if (rst) begin
      sel <= 0;
      out <= 0;
    end
  end

  // Multiplexer Logic
  always @(posedge clk) begin
    if (!rst) begin
      case(sel)
        2'b00: out <= in0;
        2'b01: out <= in1;
        2'b10: out <= in2;
        2'b11: out <= in3;
      endcase
    end
  end

  // Select Logic
  always @(posedge clk) begin
    if (!rst) begin
      sel <= {s1, s0};
    end
  end

endmodule