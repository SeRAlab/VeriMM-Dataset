module top_module(carryout, lcout, carryin, clk, clkb, in0, in1, in2, in3, sr);input carryin;
  output carryout;
  input clk;
  input clkb;
  input in0;
  input in1;
  input in2;
  input in3;
  output lcout;
  input sr;

  reg [3:0] inputs;
  reg lcout_reg;
  reg carryout_reg;

  always @(posedge clk, negedge clkb) begin
    if (!clkb) begin
      // Asynchronous reset
      lcout_reg <= 1'b0;
      carryout_reg <= 1'b0;
    end else if (sr) begin
      // Synchronous reset
      lcout_reg <= 1'b0;
      carryout_reg <= 1'b0;
    end else begin
      // Compute outputs
      inputs <= {in3, in2, in1, in0};
      lcout_reg <= |inputs;
      carryout_reg <= &inputs;
    end
  end

  assign carryout = carryin & carryout_reg;
  assign lcout = lcout_reg;

endmodule