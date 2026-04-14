module top_module(
    input clk,
    input reset,
    input ena,
    input d,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the shift register to zero
            q <= 3'b000;
        end else if (ena) begin
            // Enable: Shift left and input new data
            q <= {q[1:0], d};
        end
    end

endmodule