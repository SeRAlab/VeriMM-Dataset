module top_module(
    input [3:0] data_in,
    input [1:0] shift_amount,
    input direction_left,
    output reg [3:0] data_out
);reg [3:0] shift_reg [1:3];

always @(*) begin
    shift_reg[1] = data_in;
    shift_reg[2] = shift_reg[1] << 1;
    shift_reg[3] = shift_reg[2] << 1;
    
    if (shift_amount == 2'b00) begin
        data_out = data_in;
    end else if (shift_amount == 2'b01) begin
        data_out = shift_reg[2];
    end else if (shift_amount == 2'b10) begin
        data_out = shift_reg[3];
    end else if (shift_amount == 2'b11) begin
        data_out = direction_left ? shift_reg[3] : shift_reg[1];
    end
end

endmodule