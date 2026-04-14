module johnson_counter
(
    input clk,
    input reset,
    output reg [2:0] q
);
    always @(posedge clk) begin
        if (reset) begin
            q <= 3'b000; // Reset counter to 000
        end else begin
            q <= {~q[2], q[2:1]}; // Johnson counter sequence
        end
    end

endmodule