module top_module(
    input [3:0] data,
    input [1:0] shift_amount,
    output reg [3:0] result
);always @(*) begin
        case(shift_amount)
            2'b00: result = data;
            2'b01: result = {data[0], data[3:1]}; // Shift left by 1
            2'b10: result = {data[1:0], data[3:2]}; // Shift left by 2
            2'b11: result = {data[2:0]}; // Shift left by 3 and clear the excess
        endcase
    end

endmodule