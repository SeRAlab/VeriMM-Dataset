module decoder_4to16 (
    input [3:0] in,
    output reg [15:0] out
);
    always @(*) begin
        out = 16'b0000_0000_0000_0000; // Default to all zeros
        out[in] = 1'b1; // Set the output corresponding to the input
    end
endmodule