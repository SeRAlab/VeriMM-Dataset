module top_module(
  input clk,
  input reset,
  input load,
  input data_in,
  output reg [7:0] data_out
);reg [7:0] shift_reg;

  always @(posedge clk) begin
    if (reset) begin
      shift_reg <= 8'b0;
    end else if (load) begin
      shift_reg <= data_in;
    end else begin
      shift_reg <= {shift_reg[6:0], shift_reg[7]};
    end
  end

  assign data_out = shift_reg[7];

endmodule