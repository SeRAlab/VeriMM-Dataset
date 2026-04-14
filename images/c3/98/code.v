module barrel_shifter (
    input [3:0] data,
    input [1:0] shift,
    input shift_right,
    input shift_left,
    input rotate_right,
    input rotate_left,
    output reg [3:0] result
);

always @(*) begin
    case ({rotate_left, rotate_right, shift_left, shift_right})
        4'b0001: result = {data[2:0], data[3]};
        4'b0010: result = {data[1:0], data[3:2]};
        4'b0100: result = {data[0], data[3:1]};
        4'b1000: result = {data[3], data[2:0]};
        default: result = data;
    endcase
end

endmodule