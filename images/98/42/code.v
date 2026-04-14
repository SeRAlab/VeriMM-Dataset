module top_module(
    input clk,
    input reset,
    input ena,
    input d,
    output reg [9:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the shift register to zero
            q <= 10'b0000000000;
        end else if (ena) begin
            // Enable: Shift right and input new data
            q <= {d, q[9:1]};
        end
    end

endmodule