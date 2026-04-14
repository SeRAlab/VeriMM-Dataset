module johnson_counter(
    input clk,
    input reset,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset
            q <= 4'b0000;
        end else begin
            // Johnson counter logic
            q <= {q[2:0], ~q[3]};
        end
    end

endmodule