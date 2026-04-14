module toggle_module (
    input clk,
    input reset,
    input enable,
    output reg q
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 0;
        end else if (enable) begin
            q <= ~q;
        end
    end
endmodule