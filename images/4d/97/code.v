module top_module(
  output reg Q,  // Changed to `reg` to hold the value in procedural blocks
  input D,
  input CLK,
  input EN
);parameter [0:0] INIT = 1'b0;

  always @(posedge CLK) begin
    if (EN) begin
      Q <= D;
    end
  end

  initial begin
    Q <= INIT;
  end

endmodule