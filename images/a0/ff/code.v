module top_module(
  input clk,
  input ld,
  input d,
  output reg q
);reg [7:0] shift_reg;

always @(posedge clk) begin
  if(ld) begin
    shift_reg <= d;
  end else begin
    shift_reg <= {shift_reg[6:0], d};
  end
end

assign q = shift_reg[0];

endmodule