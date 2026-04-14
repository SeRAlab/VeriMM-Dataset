module lfsr (
  input clk,
  input en,
  output reg [11:0] lfsr);

always @(posedge clk) begin
    if (en)
        lfsr <= {lfsr[10:0], lfsr[11] ^ lfsr[8]};
end
endmodule