module top_module(
  input logic [31:0] pcout,
  input logic [3:0] state,
  input logic clk,
  input logic rst,
  output logic halt
);always_ff @(posedge clk)
    if (rst == 1) begin
    halt <= 0;
    end else if (pcout == 32'h0000000) begin
    halt <= 1;
    end else begin
    halt <= halt;
    end
    endmodule