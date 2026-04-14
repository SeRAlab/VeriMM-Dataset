module top_module(
  input clk,
  input reset,
  input [7:0] A,
  input [7:0] B,
  output reg [15:0] out
);reg [7:0] a_reg, b_reg, b_neg;
  reg [3:0] count;
  reg [15:0] partial_product;
  reg booth_enable;

  always @(posedge clk) begin
    if (reset) begin
      a_reg <= 0;
      b_reg <= 0;
      b_neg <= 0;
      count <= 0;
      partial_product <= 0;
      booth_enable <= 0;
      out <= 0;
    end else begin
      a_reg <= A;
      b_reg <= B;
      b_neg <= ~B + 1;
      booth_enable <= 1;
    end
  end

  always @(posedge clk) begin
    if (booth_enable) begin
      case (count[1:0])
        2'b00: partial_product <= 0;
        2'b01: partial_product <= {a_reg, 1'b0};
        2'b10: partial_product <= {a_reg, 1'b0} + {b_neg, 1'b0};
        2'b11: partial_product <= {8'b0, b_reg};
      endcase

      if (count[3] == 1) begin
        out <= out + partial_product;
      end

      count <= count + 1;
      if (count == 4) begin
        count <= 0;
      end
    end
  end

endmodule