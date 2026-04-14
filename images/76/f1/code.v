module top_module (
    input clk,
    input reset,
    output reg [3:0] q
);

    // Counter logic
    always @(posedge clk) begin
        if (reset)
            q <= 4'b1111;
        else
            q <= q - 1;
    end

endmodule