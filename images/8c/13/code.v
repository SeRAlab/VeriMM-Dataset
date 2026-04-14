module up_down_counter(
    input clk,
    input reset,
    input up_down,
    output reg [2:0] q);

    always @(posedge clk) begin
        if (reset) begin
            q <= 0;
        end else if (up_down) begin
            q <= q + 1;
        end else begin
            q <= q - 1;
        end
    end

endmodule