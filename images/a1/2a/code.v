module top_module(
  input logic [7:0] A,
  input logic [7:0] B,
  input logic rst,
  input logic clk,
  output logic [7:0] C
);always_ff @(posedge clk) begin
    if (rst) begin
      C <= 8'b0;
    end else begin
      C <= A & B;
    end
  end

endmodule