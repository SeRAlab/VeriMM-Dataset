module T_FlipFlop(
    input wire clk,
    input wire rst,
    input wire T,
    output reg Q
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Q <= 0;
        end else if (T) begin
            Q <= ~Q;
        end
    end
endmodule