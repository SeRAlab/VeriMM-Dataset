module top_module(
  input clk,
  input reset,
  input [3:0] data,
  output reg z
);reg [3:0] shift_reg;
  
  always @(posedge clk) begin
    if (reset) begin
      shift_reg <= 4'b0000;
      z <= 1'b0;
    end
    else begin
      shift_reg <= {shift_reg[2:0], data};
      if (shift_reg == 4'b1010) begin
        z <= 1'b1;
      end
      else begin
        z <= 1'b0;
      end
    end
  end
  
endmodule