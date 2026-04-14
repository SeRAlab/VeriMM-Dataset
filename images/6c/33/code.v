module top_module(
    input [3:0] D,
    input [1:0] S,
    output reg [3:0] Q
);always @(*) begin
    case(S)
        2'b00: Q = D; // no shift
        2'b01: Q = {D[2:0], 1'b0}; // left shift
        2'b10: Q = {1'b0, D[3:1]}; // right shift
        2'b11: Q = {D[1:0], D[3:2]}; // circular shift
    endcase
end

endmodule