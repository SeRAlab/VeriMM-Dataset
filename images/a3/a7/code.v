module top_module(clk, rst, in, count);parameter WIDTH = 8;
input clk, rst, in;
output reg [WIDTH-1:0] count;

reg in_prev;

always @(posedge clk) begin
    if (rst) begin
        count <= 0;
    end else begin
        if (in && !in_prev) begin
            count <= count + 1;
        end
    end
    in_prev <= in;
end

endmodule