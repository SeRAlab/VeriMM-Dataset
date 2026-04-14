module top_module(
  input in,
  output reg out  // Changed from wire to reg
);reg prev_state;
  
  always @(in) begin
    if (in === 1'b0 || in === 1'b1) begin
      prev_state <= in;
      out <= in;
    end
  end
  
  always @(*) begin
    if (in === 1'bx) begin
      out <= prev_state;
    end
  end
  
endmodule