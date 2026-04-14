module top_module(
  input D, CLK, DE, RESET,
  output reg Q  // Declare Q as reg in the output
);always @(posedge CLK or negedge RESET) begin
    if(!RESET) begin
      Q <= 0;
    end else if(DE) begin
      Q <= D;
    end
  end

endmodule