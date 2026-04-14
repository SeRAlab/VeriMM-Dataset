module decoder_5to32 (
    input [4:0] in,
    output reg [31:0] out
);
    always @(*) begin
        out = 32'b0; // default all outputs to 0
        out[in] = 1'b1; // activate the output corresponding to the input
    end
endmodule