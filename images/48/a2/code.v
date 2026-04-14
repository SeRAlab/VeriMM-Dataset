module top_module(
    input clk,
    input rst,
    input load,
    input [15:0] data_in,
    input shift,
    input enable,
    output reg [15:0] data_out
);always @(posedge clk) begin
        if (rst) begin
            data_out <= 16'b0;
        end else if (load) begin
            data_out <= data_in;
        end else if (enable) begin
            if (shift) begin
                data_out <= {data_out[0], data_out[15:1]};
            end
        end
    end

endmodule