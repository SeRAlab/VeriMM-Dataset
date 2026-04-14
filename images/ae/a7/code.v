module top_module(
    input [3:0] data_in,
    input [1:0] shift_amount,
    output reg [3:0] data_out
);always @(*) begin
        case (shift_amount)
            2'b00: data_out = data_in;                // No shift
            2'b01: data_out = {data_in[2:0], 1'b0};   // Shift left by 1
            2'b10: data_out = {data_in[1:0], 2'b00};  // Shift left by 2
            2'b11: data_out = {data_in[0], 3'b000};   // Shift left by 3
            default: data_out = data_in;               // Default case
        endcase
    end

endmodule