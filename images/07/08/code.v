module decoder4to16(
    input [3:0] in,
    output reg [15:0] out
);

always @(*) begin
    out = 16'b0000000000000000; // Default all outputs to 0
    out[in] = 1'b1; // Activate the output corresponding to the input value
end

endmodule