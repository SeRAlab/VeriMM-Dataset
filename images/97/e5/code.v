module top_module(
    input [3:0] A,
    input [1:0] shift,
    output reg [3:0] out
);always @(*) begin
    case(shift)
        2'b00: out = A; // no shift
        2'b01: out = {A[2:0], A[3]}; // shift right by 1
        2'b10: out = {A[1:0], A[3:2]}; // shift left by 1
        2'b11: out = {A[0], A[3:1]}; // shift left by 2
    endcase
end

endmodule