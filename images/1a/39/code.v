module T_flip_flop (
    input wire T,
    input wire clk,
    input wire reset,
    output reg Q
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= 1'b0;
        end else if (T) begin
            Q <= ~Q;
        end
    end
endmodule