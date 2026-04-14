module binary_counter_tc(
    input clk,
    input reset,
    output reg tc,
    output reg [3:0] q);

    always @(posedge clk) begin
        if (reset) begin
            q <= 0;
            tc <= 0;
        end else if (q == 4'b1111) begin
            q <= 0;
            tc <= 1;
        end else begin
            q <= q + 1;
            tc <= 0;
        end
    end

endmodule