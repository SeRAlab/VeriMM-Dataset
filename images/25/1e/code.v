module chacha20_stream(
    input clk,
    input [31:0] key,
    input [31:0] nonce,
    output reg [31:0] stream_output
);

always @(posedge clk) begin
    stream_output <= key ^ nonce; // Simple mixing function
end

endmodule