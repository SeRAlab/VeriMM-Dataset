module top_module(
    input [31:0] data_in,
    input [4:0] shift_amount,
    output reg [31:0] data_out
);always @(*) begin
        if (shift_amount >= 0) begin
            data_out = data_in << shift_amount;
        end else begin
            data_out = data_in >> (-shift_amount); // Change abs() to negate the shift_amount
        end
    end

endmodule