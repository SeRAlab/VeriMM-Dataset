module decoder_5to32 (
    input [4:0] in,       // 5-bit input
    output reg [31:0] out // 32-bit output
);
    always @(*) begin
        out = 32'b0; // Initialize output to 0
        out[in] = 1'b1; // Set the corresponding output bit
    end
endmodule