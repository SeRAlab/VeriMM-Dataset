module d_flip_flop(
    input               clk   ,
    input               rst_n ,
    input               D     ,
    output reg          Q     
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        Q <= 1'b0;
    else
        Q <= D;
end

endmodule