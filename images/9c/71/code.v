module t_flip_flop(
    input clk,
    input rst,
    input t,
    
    output reg q
);
    always @(posedge clk) begin
        if (rst) begin
            q <= 1'b0;
        end else if (t) begin
            q <= ~q;
        end
    end
endmodule