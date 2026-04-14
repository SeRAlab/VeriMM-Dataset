module decoder5to32 (
    input [4:0] A,
    output reg [31:0] Y
);
    always @(*) begin
        Y = 32'b0; // Initialize output to all zeros
        Y[A] = 1'b1; // Set the corresponding output bit
    end
endmodule