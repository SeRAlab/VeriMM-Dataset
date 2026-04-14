module decoder_5to32 (
    input [4:0] in,
    output reg [31:0] out
);
    always @(*) begin
        out = 32'b0; // Initialize output
        out[in] = 1'b1; // Activate the output corresponding to the input value
    end
endmodule