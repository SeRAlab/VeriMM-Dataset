module BitwiseAND(
    input [15:0] A,
    input [15:0] B,
    input enable,
    output reg [15:0] Y
);
    always @(*) begin
        if (enable) begin
            Y = A & B;
        end else begin
            Y = 16'b0;
        end
    end
endmodule