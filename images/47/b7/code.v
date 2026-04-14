module top_module(
    input [3:0] A,
    input [1:0] B,
    output reg [3:0] Y
);always @(*) begin
        case (B)
            2'b00: Y = A;
            2'b01: Y = {A[2:0], 1'b0};
            2'b10: Y = {1'b0, A[3:1]};
            2'b11: Y = {2'b00, A[3:2]};
        endcase
    end

endmodule