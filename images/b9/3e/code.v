module top_module(
    input [15:0] data,
    input [3:0] shift_amount,
    output reg [15:0] out
);always @(*) begin
        if (shift_amount >= 0) begin
            out = data << shift_amount;
        end else begin
            out = data >> -shift_amount;
        end
    end

endmodule