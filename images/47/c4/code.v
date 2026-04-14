module ring_counter_with_sync_reset (
    input clk,
    input reset,
    input enable,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else if (enable) begin
            q <= {q[3:0], q[4]};
        end
    end

endmodule