module gated_d_flip_flop (
    input wire D,
    input wire clk,
    input wire clk_en,
    output reg Q
);
    always @(posedge clk) begin
        if (clk_en) begin
            Q <= D;
        end
    end
endmodule