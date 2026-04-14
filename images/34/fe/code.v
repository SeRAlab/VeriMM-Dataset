module chacha20_stream_cipher(
    input wire clk,
    input wire reset,
    input wire [31:0] key,
    output reg [31:0] output_stream
);

reg [31:0] lfsr;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        lfsr <= 32'h1; // Initialize LFSR
        output_stream <= 32'h0;
    end else begin
        lfsr <= {lfsr[30:0], lfsr[31] ^ lfsr[21] ^ lfsr[1] ^ lfsr[0]}; // Example LFSR tap positions
        output_stream <= key ^ lfsr; // XOR the key with LFSR output
    end
end

endmodule