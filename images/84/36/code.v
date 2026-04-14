module top_module(
  input clk,
  input clkx2,
  input jrst_n,
  input [35:0] tw,
  output tr_clk,
  output reg [17:0] tr_data
);reg x1, x2;
  wire phase;
  reg tr_clk_reg; // Change from wire to reg to allow assignment in always block

  assign phase = x1 ^ x2;
  assign tr_clk = ~tr_clk_reg; // Continuous assignment for output clock

  always @(posedge clk or negedge jrst_n) begin
    if (!jrst_n) begin
      x1 <= 0;
    end else begin
      x1 <= ~x1;
    end
  end

  always @(posedge clkx2 or negedge jrst_n) begin
    if (!jrst_n) begin
      x2 <= 0;
      tr_clk_reg <= 0; // Change to use the register
      tr_data <= 0;
    end else begin
      x2 <= x1;
      tr_clk_reg <= ~phase; // Change to use the register
      tr_data <= phase ? tw[17:0] : tw[35:18];
    end
  end

endmodule