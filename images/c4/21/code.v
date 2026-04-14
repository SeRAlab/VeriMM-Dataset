module register_comparator (
  input clk,
  input rst,
  input check_en,
  input verbose_en,
  input [n-1:0] sig,
  input [n-1:0] rfr,
  output reg check,
  output reg verbose
);

  parameter n = 8; // set n to desired bit width

  always @(posedge clk) begin
    if (rst) begin
      sig <= 0;
      rfr <= 0;
    end else begin
      sig <= sig;
      rfr <= rfr;
      if (sig != rfr && check_en) begin
        check <= 1;
      end else begin
        check <= 0;
      end
      if (verbose_en) begin
        $display("sig: %b, rfr: %b", sig, rfr);
      end
    end
  end

endmodule