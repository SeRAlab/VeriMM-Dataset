module decoder_4_to_16 (
    input [3:0] A,
    output reg [15:0] Y
);
    always @(*) begin
        Y = 16'b0; // Default output
        Y[A] = 1'b1; // Set the corresponding output line high
    end
endmodule