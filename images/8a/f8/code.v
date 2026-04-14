module gray_counter(
    input clk,
    input reset,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset
            q <= 3'b000;
        end else begin
            // Gray code counter logic
            q <= q + 1'b1;
            q[2] <= q[2] ^ q[1];
            q[1] <= q[1] ^ q[0];
        end
    end

endmodule