module up_down_counter (
    input clk,
    input reset,
    input up_down,  // 1 for up, 0 for down
    output reg [3:0] q
);

    // Counter logic
    always @(posedge clk) begin
        if (reset)
            q <= 4'b0000;
        else if (up_down)
            q <= q + 1;
        else
            q <= q - 1;
    end

endmodule