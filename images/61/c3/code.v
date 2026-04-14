module shift_register (
  input clk,
  input reset,
  input [5:0] in,
  output reg [5:0] out);always @(posedge clk) begin
    if (reset) out <= 6'b000000;
    else out <= {out[4:0], in[5]};
end

endmodule