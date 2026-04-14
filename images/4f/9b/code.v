module top_module(
  input clk,
  input reset,
  input load,
  input shift,
  input [7:0] data_in,
  input [7:0] parallel_in,
  output [7:0] data_out
);reg [7:0] shift_reg;
  wire [7:0] shifted_data;

  assign shifted_data = {shift_reg[6:0], 1'b0};

  always @(posedge clk) begin
    if (reset) begin
      shift_reg <= 8'b0;
    end else if (load) begin
      shift_reg <= parallel_in;
    end else if (shift) begin
      shift_reg <= shifted_data;
    end else begin
      shift_reg <= data_in;
    end
  end

  assign data_out = shift_reg;

endmodule