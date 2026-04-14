module lfsr_12bit (
  input clk,
  input reset,
  output reg [11:0] lfsr);always @(posedge clk) begin
    if (reset) lfsr <= 12'b000000000001;
    else lfsr <= {lfsr[10:0], lfsr[11] ^ lfsr[10]};
end

endmodule