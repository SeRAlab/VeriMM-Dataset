module t_flip_flop (
    input wire clk,
    input wire rst_n,
    input wire t,
    output reg q
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q <= 1'b0;
        end else if (t) begin
            q <= ~q;
        end
    end

endmodule