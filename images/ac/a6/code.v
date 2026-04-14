module top_module (
    input clk,
    input reset,
    input enable,
    input up,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000;
        end else if (enable) begin
            if (up) begin
                q <= q + 1;
            end else begin
                q <= q - 1;
            end
        end
    end

endmodule