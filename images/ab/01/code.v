module top_module(
    input [15:0] data_in,
    input [3:0] shift_amount,
    output reg [15:0] data_out,
    output reg carry_out
);always @(*) begin
    if (shift_amount > 16) begin
        data_out = 16'b0;
        carry_out = data_in[15];
    end else begin
        data_out = data_in << shift_amount;
        carry_out = data_out[15];
    end
end

endmodule