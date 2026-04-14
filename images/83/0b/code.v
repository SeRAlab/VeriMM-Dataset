module top_module(clk, reset, a, b, result);input clk, reset;
input [7:0] a, b;
output reg [15:0] result;
integer i; // Declare i as an integer

always @(posedge clk) begin
    if (reset) begin
        result <= 0;
    end else begin
        result <= 0; // Reset result at the beginning of multiplication
        for (i = 0; i < 8; i = i + 1) begin
            if (a[i]) begin
                result <= result + (b << i);
            end
        end
    end
end

endmodule