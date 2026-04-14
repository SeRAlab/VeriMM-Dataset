module top_module(
    input clk,
    input areset,
    input ena,
    output reg [7:0] q
);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronous reset: Reset the counter to zero
            q <= 8'b00000000;
        end else if (ena) begin
            // Enable: Increment the counter
            q <= q + 1;
        end
    end

endmodule