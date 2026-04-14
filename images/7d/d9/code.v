module top_module(
  input [3:0] data_in,
  input shift_in,
  input load,
  input clk,
  output reg [3:0] data_out
);reg [3:0] shift_reg;

  always @(posedge clk) begin
    if (load) begin
      shift_reg <= data_in;
    end else begin
      shift_reg <= {shift_reg[2:0], shift_in};
    end
  end

  assign data_out = shift_reg;

endmodule