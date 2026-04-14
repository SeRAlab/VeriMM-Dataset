module top_module(
    input clk,
    input reset,
    input dir,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the counter to 5'b00000
            q <= 5'b00000;
        end else if (dir) begin
            // Up counter
            q <= q + 1;
        end else begin
            // Down counter
            q <= q - 1;
        end
    end

endmodule