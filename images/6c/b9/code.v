module top_module(
    input clk,
    input ena,
    output reg [3:0] q
);

    initial begin
        // Initial value of the counter
        q = 4'b1010;
    end

    always @(posedge clk) begin
        if (ena) begin
            // Enable: Increment the counter
            q <= q + 1;
        end
    end

endmodule