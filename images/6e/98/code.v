module top_module(
    input wire [31:0] data_in,
    input wire [4:0] shift_amount,
    output reg [31:0] rotated_data
    );always @(*) begin
        if (shift_amount == 0) begin
            rotated_data = data_in;
        end
        else begin
            rotated_data = (data_in << shift_amount) | (data_in >> (32 - shift_amount));
        end
    end

endmodule