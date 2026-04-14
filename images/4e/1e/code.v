module top_module(
    input [3:0] A,
    input [3:0] B,
    input [1:0] S,
    output reg [3:0] Y
);always @(*) begin
    case(S)
        2'b00: Y = A;
        2'b01: Y = {A[2:0], A[3]};
        2'b10: Y = {A[0], A[3:1]};
        2'b11: Y = {A[1:0], A[3:2]};
    endcase
end

endmodule