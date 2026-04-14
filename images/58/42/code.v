module decoder_4to16 (A, Y);
input [3:0] A;
output reg [15:0] Y;

always @(*) begin
    Y = 16'b0;
    Y[A] = 1'b1;
end

endmodule