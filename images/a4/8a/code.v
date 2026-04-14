module top_module(
    input clk,
    input reset,
    input data_in,
    input shift_in,
    output reg [7:0] data_out
);always @(posedge clk) begin
        if (reset) begin
            data_out <= 8'h00;
        end else begin
            if (shift_in) begin
                data_out <= {data_in, data_out[7:1]};
            end
        end
    end

endmodule