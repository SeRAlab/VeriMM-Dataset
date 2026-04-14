module dynamic_gate(
  input wire in,
  input wire clk,
  output reg out
);

  always @(posedge clk) begin
    if (in) out <= 1'b1;
    else out <= 1'b0;
  end

endmodule