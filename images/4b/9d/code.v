module up_down_counter (
    input clk,
    input reset,
    input ctrl,
    output reg [3:0] q
);always @(posedge clk) begin
        if (reset)
            q <= 4'b0000;
        else if (ctrl)
            q <= q + 1;
        else
            q <= q - 1;
    end

endmodule