module top_module(
    input [3:0] data_in,
    input [1:0] shift_amount,
    input direction_left,
    output reg [3:0] data_out
);always @(*) begin
        if (shift_amount == 2'b00) begin
            data_out = data_in;
        end else if (shift_amount == 2'b01) begin
            if (direction_left) begin
                data_out = {data_in[2:0], 1'b0};
            end else begin
                data_out = {1'b0, data_in[3:1]};
            end
        end else if (shift_amount == 2'b10) begin
            if (direction_left) begin
                data_out = {data_in[1:0], 2'b00};
            end else begin
                data_out = {2'b00, data_in[3:2]};
            end
        end else if (shift_amount == 2'b11) begin
            if (direction_left) begin
                data_out = {data_in[0], data_in[2:0], 1'b0};
            end else begin
                data_out = {1'b0, data_in[3], data_in[1:0]};
            end
        end
    end

endmodule