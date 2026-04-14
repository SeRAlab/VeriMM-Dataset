module top_module(CLK, D, RESET, EN, Q);input CLK, D, RESET, EN;
  output reg Q;  // Changed to reg since it will be assigned in always block
  wire E;

  assign E = EN;

  always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
      Q <= 1'b0;  // Reset output
    end else if (E) begin
      Q <= D;     // Set output based on D
    end
  end
endmodule