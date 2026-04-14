module decoder_5to32 (
    input [4:0] in,
    output reg [31:0] out
);
    always @(*) begin
        out = 32'b0; // Set all output bits to 0
        out[in] = 1'b1; // Set the output corresponding to the input
    end
endmodule