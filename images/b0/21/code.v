module top_module(
  input D,
  input SET_B,
  input RESET_B,
  input CLK,
  output reg Q,
  output Q_N
);assign Q_N = ~Q; // Complement of Q

  always @(posedge CLK or negedge SET_B or negedge RESET_B) begin
    if (!SET_B) begin
      Q <= 1'b1; // Active high set
    end else if (!RESET_B) begin
      Q <= 1'b0; // Active high reset
    end else begin
      Q <= D; // Normal D flip-flop operation
    end
  end

endmodule