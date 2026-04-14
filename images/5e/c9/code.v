module sync_counter (
    input clk,
    input enable,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (enable) begin
            q <= q + 1;
        end
    end

endmodule