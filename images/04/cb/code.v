module barrel_shifter (
    input [7:0] data_in,
    input [2:0] shift_amt,
    input mode, // 0 for left shift, 1 for right shift
    output reg [7:0] data_out
);
    
    always @(*) begin
        case (mode)
            1'b0: // Left shift
                data_out = data_in << shift_amt;
            1'b1: // Right shift
                data_out = data_in >> shift_amt;
            default:
                data_out = 8'b00000000; // Default case
        endcase
    end
endmodule