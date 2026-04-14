module top_module(
    input [15:0] data_in,
    input [3:0] shift_amount,
    input shift_direction,
    output reg [15:0] data_out
);always @(*) begin
        if (shift_direction == 1) begin
            data_out = data_in << shift_amount;
        end else begin
            data_out = data_in >> shift_amount;
        end
    end

endmodule