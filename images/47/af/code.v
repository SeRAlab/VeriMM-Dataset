module counter_4bit (
    input wire clk,
    input wire reset,
    input wire enable,
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000;
        end else if (enable) begin
            q <= q + 1;
        end
    end
endmodule