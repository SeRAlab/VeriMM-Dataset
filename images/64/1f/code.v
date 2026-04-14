module top_module(
  input clk,
  input reset,
  input [3:0] a,
  input [3:0] b,
  output reg [7:0] product
);reg [4:0] a_reg, b_reg;
  reg [2:0] count;
  reg [7:0] partial_product;
  reg [8:0] product_reg;
  reg [1:0] state;

  always @(posedge clk) begin
    if (reset) begin
      a_reg <= 0;
      b_reg <= 0;
      count <= 0;
      partial_product <= 0;
      product_reg <= 0;
      state <= 0;
    end else begin
      case (state)
        0: begin
          a_reg <= a;
          b_reg <= b;
          count <= 3;
          state <= 1;
        end
        1: begin
          if (count == 0) begin
            state <= 3;
          end else begin
            if ({a_reg[3], a_reg[2]} == 2'b01) begin
              partial_product <= b_reg << 1;
            end else if ({a_reg[3], a_reg[2]} == 2'b10) begin
              partial_product <= ~(b_reg << 1) + 1;
            end else begin
              partial_product <= 0;
            end
            count <= count - 1;
            a_reg <= {a_reg[2:0], a_reg[3]};
            state <= 2;
          end
        end
        2: begin
          partial_product <= partial_product >> 1;
          state <= 1;
        end
        3: begin
          product_reg <= {partial_product[6:0], 1'b0};
          state <= 4;
        end
        4: begin
          product_reg <= product_reg + {partial_product[7], partial_product[6:0], 1'b0};
          state <= 5;
        end
        5: begin
          product_reg <= product_reg + {partial_product[7], partial_product[6:0], 1'b0};
          state <= 6;
        end
        6: begin
          product_reg <= product_reg + {partial_product[7], partial_product[6:0], 1'b0};
          state <= 7;
        end
        7: begin
          product_reg <= product_reg + {partial_product[7], partial_product[6:0], 1'b0};
          product <= product_reg[7:0];
          state <= 0;
        end
      endcase
    end
  end

endmodule