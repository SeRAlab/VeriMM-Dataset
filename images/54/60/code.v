module top_module(
  input                clk,
  input                rst_n,
  output reg  [63:0]   Q
);reg [63:0] shift_reg;

always @(posedge clk) begin
  if (!rst_n) begin
    shift_reg <= 64'b0;
  end else begin
    shift_reg <= {shift_reg[62:0], shift_reg[63] ^ shift_reg[0]};
  end
end

assign Q = shift_reg;

endmodule