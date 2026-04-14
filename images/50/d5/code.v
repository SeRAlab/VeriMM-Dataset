module top_module(
    input [3:0] data_in,
    input [1:0] shift_amount,
    input mode,
    output reg [3:0] data_out
);reg [3:0] shift_reg1, shift_reg2, shift_reg3;

always @(*) begin
    shift_reg1 = data_in;
    shift_reg2 = shift_reg1 >> shift_amount;
    shift_reg3 = shift_reg1 << shift_amount;
end

always @(posedge mode) begin
    if (mode == 1'b0) begin
        data_out <= shift_reg2;
    end else begin
        data_out <= shift_reg3;
    end
end

endmodule