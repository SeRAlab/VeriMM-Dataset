module top_module(
    input clk,
    input reset,
    input shift_left,
    input shift_right,
    input [3:0] data_in,
    output reg [3:0] data_out
);always @(posedge clk) begin
        if (reset) begin
            data_out <= 4'b0000;
        end else if (shift_left && !shift_right) begin
            data_out <= {data_out[2:0], data_in[0]};
        end else if (shift_right && !shift_left) begin
            data_out <= {data_in[3], data_out[3:1]};
        end
    end

endmodule