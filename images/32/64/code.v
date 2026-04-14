module barrel_shifter (
    input [3:0] data_in,
    input [1:0] shift_amt,
    input direction, // 0 for left shift, 1 for right shift
    output reg [3:0] data_out
);
    
    always @(*) begin
        case ({direction, shift_amt})
            3'b000: data_out = data_in;               // No shift
            3'b001: data_out = {data_in[2:0], 1'b0};   // Left shift by 1
            3'b010: data_out = {data_in[1:0], 2'b00};  // Left shift by 2
            3'b011: data_out = {data_in[0], 3'b000};   // Left shift by 3
            3'b100: data_out = {1'b0, data_in[3:1]};   // Right shift by 1
            3'b101: data_out = {2'b00, data_in[3:2]};  // Right shift by 2
            3'b110: data_out = {3'b000, data_in[3]};   // Right shift by 3
            default: data_out = data_in;               // Default to no shift
        endcase
    end
endmodule