module fibonacci_lfsr (
  input clk,
  input en,
  input rst,
  output reg [4:0] lfsr);

always @(posedge clk) begin
    if (rst)
        lfsr <= 5'b00001;
    else if (en)
        lfsr <= {lfsr[3:0], lfsr[4] ^ lfsr[1]};
end
endmodule