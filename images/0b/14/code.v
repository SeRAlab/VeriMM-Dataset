module barrel_shifter (
    input [3:0] data_in,
    input [1:0] shift_amt,
    output reg [3:0] data_out
);
    always @(*) begin
        case (shift_amt)
            2'b00: data_out = data_in;          // No shift
            2'b01: data_out = {data_in[2:0], 1'b0}; // Left shift by 1
            2'b10: data_out = {1'b0, data_in[3:1]}; // Left shift by 2
            2'b11: data_out = {data_in[1:0], data_in[3:2]}; // Circular left shift
            default: data_out = data_in;       // Default case
        endcase
    end
endmodule