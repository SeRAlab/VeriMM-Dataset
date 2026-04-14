module top_module(
    input clk,
    input reset,
    input ena,
    input up,
    output reg [31:0] q);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'b0;
        end else if (ena) begin
            if (up) begin
                q <= q + 1;
            end else begin
                q <= q - 1;
            end
        end
    end

endmodule