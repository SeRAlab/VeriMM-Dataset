module barrel_shifter(
    input [3:0] data_in,
    input [1:0] ctrl, // Control signal: 00 = no shift, 01 = shift left, 10 = shift right, 11 = shift left by 2
    output reg [3:0] data_out
);
    always @(*) begin
        case(ctrl)
            2'b00: data_out = data_in;            // No shift
            2'b01: data_out = {data_in[2:0], 1'b0}; // Shift left by 1
            2'b10: data_out = {1'b0, data_in[3:1]}; // Shift right by 1
            2'b11: data_out = {data_in[1:0], 2'b00}; // Shift left by 2
            default: data_out = 4'b0000;          // Default case to handle unexpected values
        endcase
    end
endmodule