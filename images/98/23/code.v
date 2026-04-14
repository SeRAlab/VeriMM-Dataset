module top_module(
    input up_count,
    input down_count,
    input reset,
    input clk,
    output reg [2:0] num_entries
);always @(posedge clk) begin
    if (reset) begin
        num_entries <= 3'b0;
    end else if (up_count) begin
        num_entries <= num_entries + 1;
    end else if (down_count) begin
        num_entries <= num_entries - 1;
    end
end

endmodule