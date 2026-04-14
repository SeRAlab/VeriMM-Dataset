module top_module(
    input clk, reset, set, clear,
    input data_in,
    output reg data_out
);always @(posedge clk) begin
    if (reset) begin
        data_out <= 0;
    end else if (set) begin
        data_out <= 1;
    end else if (clear) begin
        data_out <= 0;
    end else begin
        data_out <= data_out;
    end
end

endmodule