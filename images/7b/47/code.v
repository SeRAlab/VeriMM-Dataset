module top_module(
  input CLK,
  input LOAD,
  input [3:0] D,
  input SHIFT,
  output [3:0] Q
);reg [3:0] shift_reg;

  always @(posedge CLK) begin
    if (LOAD) begin
      shift_reg <= D;
    end else if (SHIFT) begin
      shift_reg <= {shift_reg[2:0], 1'b0};
    end
  end

  assign Q = shift_reg;

endmodule