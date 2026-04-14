module top_module(out,
    in0,
    s_aclk,
    reset);output reg out;        // change output to reg to allow assignment in always block
  input in0;
  input s_aclk;
  input reset;

  reg in0_reg;          // change to reg type
  reg s_aclk_reg;
  reg Q_reg;            // declare Q_reg as reg

  // Asynchronous reset
  always @(posedge reset) begin
    in0_reg <= 1'b0;
    s_aclk_reg <= 1'b0;
    Q_reg <= 1'b0;      // reset Q_reg on reset
  end

  // Synchronize input signal to the clock domain of the module
  always @(posedge s_aclk) begin
    in0_reg <= in0;
    s_aclk_reg <= s_aclk;
  end

  // D flip-flop
  always @(posedge s_aclk_reg) begin
    Q_reg <= in0_reg;
  end

  // Assign synchronized input signal to output
  always @(posedge s_aclk_reg) begin
    out <= Q_reg;       // assign Q_reg to out on posedge of s_aclk_reg
  end

endmodule