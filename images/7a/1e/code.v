module top_module(
    input clk,
    input reset,
    input ena,
    input dir,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the counter to zero
            q <= 8'b00000000;
        end else if (ena) begin
            // Enable: Increment or decrement the counter based on direction
            if (dir) begin
                q <= q + 1;
            end else begin
                q <= q - 1;
            end
        end
    end

endmodule