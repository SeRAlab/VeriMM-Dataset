module up_down_counter_sync_reset (
    input clk,
    input reset,
    input enable,
    input dir,
    output reg [3:0] count
);

    always @(posedge clk) begin
        if (reset) begin
            count <= 4'b0000;
        end else if (enable) begin
            if (dir) begin
                count <= count + 1;
            end else begin
                count <= count - 1;
            end
        end
    end

endmodule