module T_flip_flop (
    input wire clk,
    input wire T,
    input wire reset,
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