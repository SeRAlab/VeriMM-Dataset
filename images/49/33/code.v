module top_module(
    input [3:0] data_in,
    input [1:0] shift_amount,
    input direction,
    output [3:0] data_out
);reg [3:0] shifted_data;

    always @(*) begin
        if (direction == 1'b0) // shift right
            shifted_data = data_in >> shift_amount;
        else // shift left
            shifted_data = data_in << shift_amount;
    end

    assign data_out = shifted_data;

endmodule