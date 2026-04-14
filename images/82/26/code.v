module counter_4bit_sync_reset(
    input clk,
    input rst,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (rst)
            q <= 4'b0;
        else
            q <= q + 1;
    end

endmodule