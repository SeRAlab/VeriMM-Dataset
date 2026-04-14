module top_module(D, CLK, Q, QN);parameter GATE_DELAY = 5; // propagation delay in ns
  parameter SETUP_TIME = 2; // setup time in ns
  
  output reg Q;
  output QN;
  input D, CLK;

  // Invert Q for QN output
  assign QN = ~Q;

  always @(posedge CLK) begin
    if (CLK) begin
      Q <= D; // Transfer D to Q on the rising edge of CLK
    end
  end

endmodule