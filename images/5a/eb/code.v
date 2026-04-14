module top_module(
    input clk,
    input rst,
    input d,
    output reg q
);reg d_ff;
    reg rst_ff;

    always @(posedge clk) begin
        if (rst_ff == 1'b0) begin
            d_ff <= 1'b0;
            q <= 1'b0;
        end
        else begin
            d_ff <= d;
            q <= d_ff;
        end
    end

    always @(negedge rst) begin
        rst_ff <= rst;
    end

endmodule