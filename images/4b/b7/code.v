module up_counter (
    input clk,
    input reset,
    input enable,
    output reg [3:0] q
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 4'b0000;
        end else if (enable) begin
            q <= q + 1;
        end
    end

endmodule