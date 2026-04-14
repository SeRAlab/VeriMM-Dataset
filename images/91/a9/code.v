module top_module(
    input clk,
    input reset,
    output reg [3:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0001; // Reset the ring counter to 0001
        end else begin
            q <= {q[2:0], q[3]}; // Rotate the ring counter
        end
    end

endmodule