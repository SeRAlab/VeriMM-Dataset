module BitwiseLeftShift(
    input [7:0] data_in,
    input [2:0] shift_amount,
    output reg [7:0] data_out
    );

    always @(*) begin
        if (shift_amount > 7) begin
            data_out = 8'b0;
        end else begin
            data_out = data_in << shift_amount;
        end
    end

endmodule