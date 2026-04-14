module decoder_5to32 (
    input wire [4:0] in,  // 5-bit input
    output reg [31:0] out  // 32-bit output
);
    always @(*) begin
        out = 32'b0; // Initialize output to all zeros
        out[in] = 1'b1; // Set the output line corresponding to the input
    end
endmodule