module top_module(
    input clk,
    input reset,
    input ena,
    input dir,
    output reg [7:0] q);

    always @(posedge clk) begin
        if (reset) begin
            q <= 8'b0;
        end else if (ena) begin
            if (dir) begin
                q <= q + 1;
            end else begin
                q <= q - 1;
            end
        end
    end

endmodule