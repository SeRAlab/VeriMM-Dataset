module top_module(
    input [3:0] D,
    input [1:0] S,
    input shift_right,
    output reg [3:0] Q
);always @(*) begin
    case(S)
        2'b00: Q = D; // no shift
        2'b01: Q = shift_right ? {D[3], D[3:1]} : {D[2:0], D[0]}; // shift 1 bit
        2'b10: Q = shift_right ? {D[3:2], D[3:1]} : {D[1:0], D[3:2]}; // shift 2 bits
        2'b11: Q = shift_right ? {D[3:1], D[3]} : {D[0], D[2:0]}; // shift 3 bits
    endcase
end

endmodule