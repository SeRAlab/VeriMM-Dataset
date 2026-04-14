module top_module(
    input [3:0] data_in,
    input [3:0] shift_amount,
    output reg [3:0] data_out
);always @(*) begin
        if (shift_amount >= 0) begin
            data_out = data_in << shift_amount;
        end else begin
            data_out = data_in >> (-shift_amount);
        end
    end

endmodule