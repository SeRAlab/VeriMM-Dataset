module decoder3to8 (
    input [2:0] A,
    output reg [7:0] Y
);
    always @(*) begin
        Y = 8'b00000000; // Default all outputs to 0
        Y[A] = 1'b1;     // Set the output corresponding to the input
    end
endmodule