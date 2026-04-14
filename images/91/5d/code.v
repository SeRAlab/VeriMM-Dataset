module top_module(
  input clk,
  input reset,
  input serial_in,
  output serial_out,
  output reg [31:0] parallel_out
);reg [31:0] shift_reg;

always @(posedge clk) begin
  if (reset) begin
    shift_reg <= 0;
  end else begin
    shift_reg <= {shift_reg[30:0], serial_in};
  end
end

assign serial_out = shift_reg[31];
assign parallel_out = shift_reg;

endmodule