module top_module(
    input clk,
    input reset,
    output reg [3:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000; // Reset the Johnson counter to 0000
        end else begin
            q <= {~q[0], q[3:1]}; // Rotate and invert the Johnson counter
        end
    end

endmodule