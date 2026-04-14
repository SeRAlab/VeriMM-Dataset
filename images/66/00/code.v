module top_module(
    input [3:0] data,
    input shift_left,
    input shift_right,
    input rotate_right,
    output reg [3:0] shifted_data
);always @(*) begin
        if (shift_left) begin
            shifted_data = {data[2:0], 1'b0};
        end else if (shift_right) begin
            shifted_data = {1'b0, data[3:1]};
        end else if (rotate_right) begin
            shifted_data = {data[0], data[3:1]};
        end else begin
            shifted_data = data;
        end
    end

endmodule