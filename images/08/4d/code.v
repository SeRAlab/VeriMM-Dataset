module barrel_shifter (
    input [1:0] data_in,
    input shift_dir, // 0 for left shift, 1 for right shift
    output reg [1:0] data_out
);
    always @(*) begin
        case (shift_dir)
            1'b0: data_out = {data_in[0], data_in[1]}; // Left shift
            1'b1: data_out = {data_in[1], data_in[0]}; // Right shift
            default: data_out = 2'b00; // Default case
        endcase
    end
endmodule