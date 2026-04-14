module top_module(
    input [7:0] data_in,
    input [2:0] shift_amount,
    input shift_direction,
    output [7:0] data_out
);reg [7:0] shifted_data;

    always @(*) begin
        if (shift_direction == 1'b0) begin
            shifted_data = data_in >> shift_amount;
        end else begin
            shifted_data = data_in << shift_amount;
        end
    end

    assign data_out = shifted_data;

endmodule