module top_module (
    input clk,
    input reset,
    input count_enable,
    input up_down,
    output reg [3:0] q
);

    // Binary counter with count enable and up/down control logic
    always @(posedge clk) begin
        if (reset)
            q <= 4'b0000;
        else if (count_enable) begin
            if (up_down)
                q <= q + 1;
            else
                q <= q - 1;
        end
    end

endmodule