module fixed_priority_arbiter (
    input wire clk,
    input wire rst,
    input wire r0,
    input wire r1,
    input wire r2,
    input wire r3,
    output reg g0,
    output reg g1,
    output reg g2,
    output reg g3
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            g0 <= 0;
            g1 <= 0;
            g2 <= 0;
            g3 <= 0;
        end else begin
            g0 <= r0;
            g1 <= r1 && !r0;
            g2 <= r2 && !r0 && !r1;
            g3 <= r3 && !r0 && !r1 && !r2;
        end
    end
endmodule