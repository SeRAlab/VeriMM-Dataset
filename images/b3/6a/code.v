module top_module(
    input [31:0] data,
    input [4:0] shift,
    input shift_right,
    output reg [31:0] shifted_data
);always @(*) begin
        if (shift_right) begin
            shifted_data = data >> shift;
        end else begin
            shifted_data = data << shift;
        end
    end

endmodule