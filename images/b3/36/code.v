module top_module(
    input [15:0] A,
    input [15:0] B,
    input [3:0] shift,
    output reg [15:0] out
);always @(*) begin
        case (shift)
            4'd0:    out = B;                           // No shift
            4'd1:    out = {A[14:0], 1'b0};             // Logical left shift by 1
            4'd2:    out = {A[13:0], 2'b00};             // Logical left shift by 2
            4'd3:    out = {A[12:0], 3'b000};             // Logical left shift by 3
            4'd4:    out = {A[11:0], 4'b0000};             // Logical left shift by 4
            4'd5:    out = {A[10:0], 5'b00000};             // Logical left shift by 5
            4'd6:    out = {A[9:0], 6'b000000};             // Logical left shift by 6
            4'd7:    out = {A[8:0], 7'b0000000};             // Logical left shift by 7
            4'd8:    out = {A[7:0], 8'b00000000};            // Logical left shift by 8
            4'd9:    out = {A[6:0], 9'b000000000};           // Logical left shift by 9
            4'd10:   out = {A[5:0], 10'b0000000000};         // Logical left shift by 10
            4'd11:   out = {A[4:0], 11'b00000000000};        // Logical left shift by 11
            4'd12:   out = {A[3:0], 12'b000000000000};       // Logical left shift by 12
            4'd13:   out = {A[2:0], 13'b0000000000000};      // Logical left shift by 13
            4'd14:   out = {A[1:0], 14'b00000000000000};     // Logical left shift by 14
            4'd15:   out = {A[0], 15'b000000000000000};      // Logical left shift by 15
            default: out = 16'b0;                            // Default case
        endcase
    end

endmodule