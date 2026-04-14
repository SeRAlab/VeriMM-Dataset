module top_module(
    input [3:0] data,
    input [1:0] shift_amount,
    output reg [3:0] result
);always @(*) begin
    case(shift_amount)
        2'b00: result = data;
        2'b01: result = {data[2:0], 1'b0};
        2'b10: result = {data[1:0], 2'b00};
        2'b11: result = {data[0], 3'b000};
    endcase
end

endmodule