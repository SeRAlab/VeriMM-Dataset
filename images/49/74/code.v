module top_module(
    input [3:0] A,
    input [3:0] B,
    input DIR,
    input [1:0] AMT,
    output reg [3:0] S
);always @(*) begin
        if (DIR == 0) begin
            case (AMT)
                2'b00: S = A;                       // No shift
                2'b01: S = {A[2:0], B[3]};          // Shift left by 1
                2'b10: S = {A[1:0], B[3:2]};        // Shift left by 2
                2'b11: S = {B[3], A[3:1]};          // Shift left by 3
                default: S = A;                     // Default case
            endcase
        end else begin
            case (AMT)
                2'b00: S = A;                       // No shift
                2'b01: S = {B[0], A[3:1]};          // Shift right by 1
                2'b10: S = {B[1:0], A[3:2]};        // Shift right by 2
                2'b11: S = {B[2:0], A[3]};          // Shift right by 3
                default: S = A;                     // Default case
            endcase
        end
    end

endmodule