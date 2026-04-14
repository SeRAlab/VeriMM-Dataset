module top_module(
  input CLK,
  input D,
  input SET,
  input RESET,
  output reg Q,   // Changed to output reg
  output QN      // Left as wire
);// Removing reg declaration for QN since it's not needed
  assign QN = ~Q; // QN can stay as a wire

  always @(posedge CLK or negedge SET or negedge RESET) begin
    if (!SET) begin
      Q <= 1'b1;
    end else if (!RESET) begin
      Q <= 1'b0;
    end else begin
      Q <= D;
    end
  end

endmodule