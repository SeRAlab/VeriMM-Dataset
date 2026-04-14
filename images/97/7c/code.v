module top_module(
    input clk,
    input rst,
    output reg [31:0] count
);parameter MAX_VALUE = 16;

always @(posedge clk) begin
    if (rst) begin
        count <= 0;
    end else begin
        if (count == MAX_VALUE) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end
end

endmodule