module D_flip_flop (
    input wire D,
    input wire clk,
    input wire rst,
    output reg Q
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Q <= 1'b0;
        end else begin
            Q <= D;
        end
    end
endmodule