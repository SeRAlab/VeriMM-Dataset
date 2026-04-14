module top_module(
    input [3:0] A,
    input [1:0] B,
    output reg [3:0] Y // Change output to reg type
);always @(*) begin
        case(B)
            2'b00: Y = A; // no shift
            2'b01: Y = {A[2:0], 1'b0}; // shift left by 1 bit
            2'b10: Y = {1'b0, A[3:1]}; // shift right by 1 bit
            2'b11: Y = {2'b00, A[3:2]}; // shift right by 2 bits
            default: Y = 4'b0000; // default case for safety
        endcase
    end

endmodule