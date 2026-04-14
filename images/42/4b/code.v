module top_module(
    input [2:0] A,
    input [2:0] B,
    input [2:0] C,
    output reg [1:0] Y
);wire Y1_0, Y1_1, Y2_0, Y2_1;

    assign Y1_0 = (A[0] & A[1]) | (B[0] & B[1]) | C[0];
    assign Y2_0 = (A[0] & A[1]) | (C[0] & C[1]) | B[0];
    assign Y1_1 = (A[2] & Y1_0) | (B[2] & Y2_0) | C[2];
    assign Y2_1 = (A[2] & Y1_0) | (C[2] & Y2_0) | B[2];

    always @(*) begin
        if (Y1_1 == 0 && Y2_1 == 0) begin
            Y = 2'b00;
        end else if (Y1_1 == 0 && Y2_1 == 1) begin
            Y = 2'b01;
        end else if (Y1_1 == 1 && Y2_1 == 0) begin
            Y = 2'b10;
        end else begin
            Y = 2'b11;
        end
    end

endmodule