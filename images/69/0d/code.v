module up_down_counter(
    input clk,
    input enable,
    input up_down,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (enable) begin
            if (up_down) begin
                q <= q + 1; // Increment the counter
            end else begin
                q <= q - 1; // Decrement the counter
            end
        end
    end

endmodule