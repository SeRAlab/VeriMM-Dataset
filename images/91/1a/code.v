module top_module(input wire clk, input wire sel, input wire in, output wire outA, output wire outB, output wire outC, output wire outD);reg outA_reg, outB_reg, outC_reg, outD_reg;

  always @(posedge clk) begin
    if (sel == 2'b00) begin
      outA_reg <= in;
    end else if (sel == 2'b01) begin
      outB_reg <= in;
    end else if (sel == 2'b10) begin
      outC_reg <= in;
    end else begin
      outD_reg <= in;
    end
  end

  assign outA = outA_reg;
  assign outB = outB_reg;
  assign outC = outC_reg;
  assign outD = outD_reg;

endmodule