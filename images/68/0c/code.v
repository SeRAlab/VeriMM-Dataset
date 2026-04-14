module lfsr_5bit(
    input clk,
    input reset,
    output reg [4:0] lfsr);always @(posedge clk) begin
    if (reset)
        lfsr <= 5'b00001;
    else
        lfsr <= {lfsr[3:0], lfsr[4] ^ lfsr[2]};
end
endmodule