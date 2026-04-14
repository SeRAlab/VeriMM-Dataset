module barrel_shifter(
    input [3:0] data_in,
    input direction, // 0 for left shift, 1 for right shift
    output reg [3:0] data_out
);
    always @(*) begin
        case (direction)
            1'b0: // Left shift
                data_out = {data_in[2:0], 1'b0}; // Shift left and fill with 0
            1'b1: // Right shift
                data_out = {1'b0, data_in[3:1]}; // Shift right and fill with 0
            default: 
                data_out = 4'b0000; // Default case (should not occur)
        endcase
    end
endmodule