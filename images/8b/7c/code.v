module top_module(
    input clk,
    input reset,
    output reg [3:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0001;  // Synchronous reset to 4'b0001
        end else begin
            q <= {q[2:0], q[3]};  // Ring counter shifting
        end
    end

endmodule