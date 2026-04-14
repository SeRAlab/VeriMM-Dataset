module top_module(
    input clk,
    input reset,
    input load,
    input [15:0] data_in,
    input shift_en,
    input shift_left,
    output reg [15:0] data_out
);always @(posedge clk, posedge reset) begin
    if (reset) begin
        data_out <= 16'b0;
    end else if (load) begin
        data_out <= data_in;
    end else if (shift_en) begin
        if (shift_left) begin
            data_out <= {data_out[14:0], 1'b0};
        end else begin
            data_out <= {1'b0, data_out[15:1]};
        end
    end
end

endmodule