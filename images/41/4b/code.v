module top_module(
    input clk,
    input reset,
    input ena,
    input d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the shift register to zero
            q <= 8'b00000000;
        end else if (ena) begin
            // Enable: Shift left and input new data
            q <= {q[6:0], d};
        end
    end

endmodule