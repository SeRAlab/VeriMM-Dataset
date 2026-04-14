module register16_with_enable(
    input clk,
    input [15:0] in,
    input write,
    input reset,
    input enable,
    output reg [15:0] out
);

    always @(posedge clk) begin
        if (reset) begin
            out <= 16'b0;
        end else if (enable) begin
            if (write) begin
                out <= in;
            end
        end
    end

endmodule