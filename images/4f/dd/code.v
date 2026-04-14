module top_module(
  input [3:0] a,
  input [3:0] b,
  input clk,
  output reg [7:0] result, // Changed to reg
  output done
);reg [7:0] partial_products;
  reg [1:0] state; // Changed to 2 bits width
  reg done_reg;

  always @(posedge clk) begin
    case (state)
      2'b00: begin // idle
        if (done_reg) begin
          state <= 2'b01; // multiply
          done_reg <= 0; // Clear done_reg for the next multiplication
        end
      end
      2'b01: begin // multiply
        partial_products <= {a, 4'b0} * {b, 4'b0};
        state <= 2'b10; // sum
      end
      2'b10: begin // sum
        result <= partial_products[7:0] + partial_products[15:8];
        done_reg <= 1;
        state <= 2'b00; // idle
      end
    endcase
  end

  assign done = done_reg;

endmodule