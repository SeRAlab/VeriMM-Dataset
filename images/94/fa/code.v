module top_module(
  input [n-1:0] in,
  input clk,
  input rst,
  output reg [m-1:0] out // Change from wire to reg
);parameter n = 4; // number of input signals
parameter m = 2; // number of output signals

reg [n-1:0] in_ff; // flip-flop for input signals
reg [m-1:0] out_ff; // flip-flop for output signals

always @(posedge clk) begin
  if (rst) begin
    in_ff <= 0;
    out_ff <= 0;
    out <= 0; // Added to reset the output as well
  end else begin
    // Asynchronous-to-synchronous synchronizer
    in_ff <= in;
    out_ff <= in_ff;
    
    // Synchronous-to-asynchronous synchronizer
    out <= out_ff; // Now out can be assigned since it's a reg
  end
end

endmodule