module top_module(CLK, D, R, Q);input CLK, D, R;
  output reg Q;  // Changed to 'reg' to hold the latch state

  always @(posedge CLK or posedge R) begin
    if (R) begin
      Q <= 1'b0;
    end else begin
      Q <= D;  // Directly assign D to Q
    end
  end

endmodule