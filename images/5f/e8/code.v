module top_module(
  input clk,
  input rst,
  input check_en,
  input verbose_en,
  input [n-1:0] sig,
  input [n-1:0] rfr,
  output reg check,
  output reg verbose
);parameter n = 8; // set n to desired bit width
  reg [n-1:0] sig_reg; // Internal register for sig
  reg [n-1:0] rfr_reg; // Internal register for rfr

  always @(posedge clk) begin
    if (rst) begin
      sig_reg <= 0;
      rfr_reg <= 0;
    end else begin
      sig_reg <= sig; // Update internal register with input
      rfr_reg <= rfr; // Update internal register with input
      if (sig_reg != rfr_reg && check_en) begin
        check <= 1;
      end else begin
        check <= 0;
      end
      if (verbose_en) begin
        $display("sig: %b, rfr: %b", sig_reg, rfr_reg);
      end
    end
  end

endmodule