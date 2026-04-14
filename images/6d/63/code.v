module top_module(
    input [15:0] data_in,
    input [3:0] shift_amount,
    output reg [15:0] data_out, // Changed wire to reg to store the output in always block
    output overflow
);assign overflow = (shift_amount > 4'b1111) ? 1'b1 : 1'b0; // check for overflow

    always @(*) begin
        case (shift_amount)
            4'b0000: data_out = data_in; // no shift
            4'b0001: data_out = {data_in[14:0], 1'b0}; // shift left by 1
            4'b0010: data_out = {data_in[13:0], 2'b00}; // shift left by 2
            4'b0011: data_out = {data_in[12:0], 3'b000}; // shift left by 3
            4'b0100: data_out = {data_in[11:0], 4'b0000}; // shift left by 4
            4'b0101: data_out = {data_in[10:0], 5'b00000}; // shift left by 5
            4'b0110: data_out = {data_in[9:0], 6'b000000}; // shift left by 6
            4'b0111: data_out = {data_in[8:0], 7'b0000000}; // shift left by 7
            4'b1000: data_out = {data_in[7:0], 8'b00000000}; // shift left by 8
            4'b1001: data_out = {data_in[6:0], 9'b000000000}; // shift left by 9
            4'b1010: data_out = {data_in[5:0], 10'b0000000000}; // shift left by 10
            4'b1011: data_out = {data_in[4:0], 11'b00000000000}; // shift left by 11
            4'b1100: data_out = {data_in[3:0], 12'b000000000000}; // shift left by 12
            4'b1101: data_out = {data_in[2:0], 13'b0000000000000}; // shift left by 13
            4'b1110: data_out = {data_in[1:0], 14'b00000000000000}; // shift left by 14
            4'b1111: data_out = {data_in[0], 15'b000000000000000}; // shift left by 15
            default: data_out = data_in; // Handle any unexpected values
        endcase
    end
endmodule