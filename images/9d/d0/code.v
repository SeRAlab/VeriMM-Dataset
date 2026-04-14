module top_module(
    input [15:0] data_in,
    input [3:0] shift_amount,
    input control,
    output [15:0] data_out
);reg [15:0] shifted_data;

    always @(*) begin
        if (control == 1) begin
            shifted_data = data_in << shift_amount;
        end else begin
            shifted_data = data_in >> shift_amount;
        end
    end

    assign data_out = shifted_data;

endmodule