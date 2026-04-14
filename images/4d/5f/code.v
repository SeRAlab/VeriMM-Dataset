module johnson_counter
(
    input clk,
    input reset,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000; // Reset to 0000
        end else begin
            q <= {~q[3], q[3:1]}; // Johnson counter shift
        end
    end

endmodule