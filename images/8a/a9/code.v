module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] C  // Changed from wire to reg
);always @(*) begin
        case(B)
            4'b0000: C = A;
            4'b0001: C = {A[2:0], 1'b0};
            4'b0010: C = {A[1:0], 2'b00};
            4'b0011: C = {A[0], A[3:1]};
            4'b0100: C = {3'b000, A[3]};
            4'b0101: C = {2'b00, A[3:2], 1'b0};
            4'b0110: C = {1'b0, A[3:1], 1'b0};
            4'b0111: C = {A[3:0], 1'b0};
            4'b1000: C = {A[2:0], A[3]};
            4'b1001: C = {A[1:0], A[3:2]};
            4'b1010: C = {A[0], A[3:1], 1'b0};
            4'b1011: C = {3'b000, A[2:0]};
            4'b1100: C = {2'b00, A[3:1], 1'b0};
            4'b1101: C = {1'b0, A[3:2], 2'b00};
            4'b1110: C = {A[3], A[2:0], 1'b0};
            4'b1111: C = A;  // Use A directly instead of duplicating
            default: C = 4'b0000;  // Handling unexpected cases
        endcase
    end

endmodule