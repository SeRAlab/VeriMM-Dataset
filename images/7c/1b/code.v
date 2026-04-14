module top_module (
    input clk,
    input reset_n,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (!reset_n)
            q <= 4'b1111; // Synchronous reset to '1111'
        else
            q <= q - 1; // Decrement counter
    end

endmodule