module d_flip_flop(
    input wire D,
    input wire clk,
    input wire rst,
    output reg Q
    );

always @(posedge clk or posedge rst) begin
    if (rst)
        Q <= 1'b0;
    else
        Q <= D;
end

endmodule