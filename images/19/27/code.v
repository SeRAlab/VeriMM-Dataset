module T_flip_flop (
    input clk,
    input rst,
    input T,
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