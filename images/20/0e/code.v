module clock_gated_d_ff (
    input wire D,
    input wire clk,
    input wire ce,
    input wire rst,
    output reg Q
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Q <= 0;
        end else if (ce) begin
            Q <= D;
        end
    end
endmodule