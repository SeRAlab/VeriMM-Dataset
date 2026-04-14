module clock_gate_en (
  input clk,
  input en,
  input data_in,
  output reg data_out
);

always @(posedge clk) begin
  if (en) begin
    data_out <= data_in;
  end else begin
    data_out <= 1'b0;
  end
end

endmodule