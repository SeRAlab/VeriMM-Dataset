module top_module(
  input clk,
  input reset,
  input shift,
  input [3:0] D,
  output reg Q
);reg [3:0] shift_reg;

  always @(posedge clk) begin
    if (reset) begin
      shift_reg <= 4'b0000;
      Q <= 1'b0;
    end
    else begin
      if (shift) begin
        shift_reg <= {shift_reg[2:0], D[0]};
        Q <= shift_reg[3];
      end
      else begin
        shift_reg <= D;
        Q <= shift_reg[3];
      end
    end
  end

endmodule