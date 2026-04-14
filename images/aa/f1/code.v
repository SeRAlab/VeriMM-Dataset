module top_module(
  input clk,
  input rst,
  input [7:0] a,
  input [7:0] b,
  input [1:0] ctrl,
  output [7:0] result,
  output valid
);reg [7:0] result_reg;
  reg valid_reg;

  always @ (posedge clk) begin
    if (rst) begin
      result_reg <= 0;
      valid_reg <= 0;
    end else begin
      case (ctrl)
        2'b00: result_reg <= a + b;
        2'b01: result_reg <= a - b;
        2'b10: result_reg <= a * b;
        2'b11: begin
          if (b == 0) begin
            result_reg <= 0;
            valid_reg <= 0;
          end else begin
            result_reg <= a / b;
            valid_reg <= 1;
          end
        end
      endcase
    end
  end

  assign result = result_reg;
  assign valid = valid_reg;

endmodule