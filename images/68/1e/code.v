module top_module(
    input clk,
    input reset,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 8'b00000000;  // Synchronous reset to 0
        end else begin
            if (q[3:0] == 4'b1001) begin
                if (q[7:4] == 4'b1001) begin
                    q <= 8'b00000000;  // Reset both BCD digits after 99
                end else begin
                    q <= {q[7:4] + 1, 4'b0000};  // Increment the tens place
                end
            end else begin
                q <= q + 1;  // Increment the units place
            end
        end
    end

endmodule