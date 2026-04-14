module barrel_shifter(
    input [1:0] data_in,
    input shift,
    output reg [1:0] data_out
);

always @(*) begin
    case (shift)
        1'b0: data_out = {data_in[0], 1'b0}; // Shift left
        1'b1: data_out = {1'b0, data_in[1]}; // Shift right
        default: data_out = 2'b00; // Default case
    endcase
end

endmodule