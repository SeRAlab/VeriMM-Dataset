module top_module(
    input clk,
    input reset,
    input dir,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the counter to 3'b000
            q <= 3'b000;
        end else begin
            // Up/Down counter based on dir signal
            if (dir) begin
                q <= q + 1;
            end else begin
                q <= q - 1;
            end
        end
    end

endmodule