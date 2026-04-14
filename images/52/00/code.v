module d_ff_sync_reset(
    input clk, rst, d,
    output reg q);

    always @(posedge clk) begin
        if (rst)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule