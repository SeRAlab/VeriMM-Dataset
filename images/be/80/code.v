module top_module(
    input wire clk,
    input wire reset,
    input wire [31:0] max_count,
    input wire count_en,
    output reg [31:0] count
);always @(posedge clk) begin
    if (reset) begin
        count <= 0;
    end else if (count_en) begin
        if (count == max_count - 1) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end
end

endmodule