module decoder5to32 (
    input [4:0] A,
    output reg [31:0] Y
);
    always @(*) begin
        Y = 32'b0; // Initialize outputs to 0
        Y[A] = 1'b1; // Activate the output line corresponding to the input
    end
endmodule