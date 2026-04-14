module barrel_shifter (
    input [7:0] data_in,
    input [2:0] shift_amt,
    input [1:0] op_code,
    output reg [7:0] data_out
);
    always @(*) begin
        case (op_code)
            2'b00: data_out = data_in << shift_amt; // Logical Shift Left
            2'b01: data_out = data_in >> shift_amt; // Logical Shift Right
            2'b10: data_out = (data_in >> shift_amt) | (data_in << (8 - shift_amt)); // Rotate Right
            default: data_out = 8'b00000000; // Default case
        endcase
    end
endmodule