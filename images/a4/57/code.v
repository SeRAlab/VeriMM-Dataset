module fibonacci_lfsr (
    input clk,
    input reset,
    output reg [2:0] lfsr);

always @(posedge clk) begin
    if (reset) begin
        lfsr <= 3'b001;
    end else begin
        lfsr <= {lfsr[1], lfsr[0], lfsr[2] ^ lfsr[1]};
    end
end
endmodule