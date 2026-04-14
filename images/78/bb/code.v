module top_module (
    input clk,
    input enable,
    input reset,
    input [3:0] d,
    output reg [3:0] q
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 4'b0;
        end else if (enable) begin
            q <= d;
        end
    end

endmodule