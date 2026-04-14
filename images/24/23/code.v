module T_flip_flop (
    input clk,
    input reset,
    input T,
    output reg Q
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= 0;
        end else if (T) begin
            Q <= ~Q;
        end
    end
endmodule