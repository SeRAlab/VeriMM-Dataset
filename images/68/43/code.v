module top_module(
  input clk,
  input reset,
  input load,
  input [3:0] din,
  output [3:0] dout
);reg [3:0] shift_reg;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    shift_reg <= 4'd0;
  end else if (load) begin
    shift_reg <= din;
  end else begin
    shift_reg <= {shift_reg[2:0], shift_reg[3]};
  end
end

assign dout = shift_reg;

endmodule