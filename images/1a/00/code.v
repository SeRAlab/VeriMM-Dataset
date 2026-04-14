module decoder5to32 (
    input [4:0] in,
    output reg [31:0] out
);
    always @(*) begin
        out = 32'b0; // Clear all outputs
        out[in] = 1'b1; // Set the appropriate output high
    end
endmodule