module barrel_shifter(
    input [1:0] data_in,
    input dir, // direction: 0 for left, 1 for right
    output reg [1:0] data_out
);

always @(*) begin
    case (dir)
        1'b0: data_out = {data_in[0], data_in[1]}; // Shift left by 1
        1'b1: data_out = {data_in[1], data_in[0]}; // Shift right by 1
        default: data_out = data_in; // No shift if dir is not defined
    endcase
end
endmodule