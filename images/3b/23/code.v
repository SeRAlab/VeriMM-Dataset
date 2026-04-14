module barrel_shifter (
    input [7:0] data_in,
    input [2:0] shift_amt,
    input mode,
    output reg [7:0] data_out
);
    always @(*) begin
        case (mode)
            1'b0: // Logical Left Shift
                data_out = data_in << shift_amt;
            1'b1: // Logical Right Shift
                data_out = data_in >> shift_amt;
            default:
                data_out = 8'b00000000; // Default case (should not occur)
        endcase
    end
endmodule