module decoder_5to32 (
    input [4:0] in,
    output reg [31:0] out
);
    always @(*) begin
        out = 32'b0; // Initialize output to zero
        out[in] = 1'b1; // Set the one-hot encoded output
    end
endmodule