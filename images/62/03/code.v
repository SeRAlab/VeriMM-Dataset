module top_module(
  input clk,
  input reset,
  input [7:0] data_in,
  input shift_control,
  output [7:0] data_out,
  output shift_done
);reg [7:0] shift_reg;
  reg [2:0] shift_count;
  reg shift_done_reg;

  always @(posedge clk, posedge reset) begin
    if (reset) begin
      shift_reg <= 8'b0;
      shift_count <= 3'b0;
      shift_done_reg <= 1'b0;
    end else begin
      if (shift_count == 3'b111) begin
        shift_done_reg <= 1'b1;
      end else begin
        shift_done_reg <= 1'b0;
      end

      if (shift_control) begin
        shift_reg <= {shift_reg[6:0], data_in};
        shift_count <= shift_count + 1;
      end else begin
        shift_reg <= {data_in, shift_reg[7:1]};
        shift_count <= shift_count + 1;
      end
    end
  end

  assign data_out = shift_reg;
  assign shift_done = shift_done_reg;

endmodule