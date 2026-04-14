module johnson_counter_3bit(
    input clk,          // Clock signal.
    input rst_n,        // Active-low asynchronous reset.
    output reg [2:0] q  // 3-bit counter output.
);

// Johnson counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q <= 3'b000;
    end else begin
        q <= {~q[2], q[2:1]};
    end
end

endmodule