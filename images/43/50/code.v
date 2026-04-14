module top_module(
  input clk,
  input reset,
  input [3:0] data_in,
  input shift_dir,
  input parallel_load,
  output reg [3:0] data_out
);reg [3:0] shift_reg;

  always @(posedge clk) begin
    if (reset) begin
      shift_reg <= 4'b0;
    end else if (parallel_load) begin
      shift_reg <= data_in;
    end else begin
      if (shift_dir) begin
        shift_reg <= {shift_reg[2:0], shift_reg[3]};
      end else begin
        shift_reg <= {shift_reg[0], shift_reg[3:1]};
      end
    end
  end

  assign data_out = shift_reg;

endmodule