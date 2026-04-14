module top_module(
  input clk,
  input reset,
  input signed [15:0] a,
  input signed [15:0] b,
  output reg signed [31:0] p
);reg signed [15:0] a_reg;
  reg signed [15:0] b_reg;
  reg [4:0] count;
  reg [16:0] ac;
  reg [1:0] q;
  reg signed [31:0] p_reg;
  wire signed [15:0] negate_b;
  wire signed [31:0] negate_p;

  assign negate_b = ~b + 1;
  assign negate_p = ~p_reg + 1;

  always @(posedge clk) begin
    if (reset) begin
      a_reg <= 0;
      b_reg <= 0;
      count <= 0;
      ac <= 0;
      q <= 0;
      p_reg <= 0;
    end else begin
      a_reg <= a;
      b_reg <= b;
      count <= 0;
      ac <= {a_reg, 1'b0};
      q <= 2'b0;
      p_reg <= 0;
    end
  end

  always @(posedge clk) begin
    if (~reset) begin
      case (q)
        2'b01: begin
          ac <= ac + negate_b;
          q <= {ac[0], 1'b1};
        end
        2'b10: begin
          ac <= ac + b_reg;
          q <= {ac[0], 1'b0};
        end
        default: begin end
      endcase

      if (count == 15) begin
        p <= p_reg;
      end else begin
        count <= count + 1;
        {q, ac} <= {ac[0], ac >> 1};
        p_reg <= {p_reg[30:0], q[1]};
      end
    end
  end

endmodule