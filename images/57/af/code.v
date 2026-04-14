module top_module(
    input [15:0] data,
    input [3:0] shift_amount,
    output reg [15:0] shifted_data
);always @(*) begin
        if (shift_amount > 15) begin
            shifted_data = 0;
        end else begin
            shifted_data = data << shift_amount;
        end
    end

endmodule