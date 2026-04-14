module toggle_flip_flop (
    input clk,
    input reset,
    output reg q
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 0;
        end else begin
            q <= ~q;
        end
    end
endmodule