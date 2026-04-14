module barrel_shifter (
    input [1:0] in,
    input ctrl,
    output reg [1:0] out
);

always @(*) begin
    case (ctrl)
        1'b0: out = {in[0], 1'b0};  // Shift left
        1'b1: out = {1'b0, in[1]};  // Shift right
        default: out = 2'b00;       // Default case
    endcase
end

endmodule