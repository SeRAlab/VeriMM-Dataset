module d_flip_flop(
    input wire clk,
    input wire rst,
    input wire D,
    output reg Q
    );

always @(posedge clk or posedge rst) begin
    if (rst)
        Q <= 1'b0;
    else
        Q <= D;
end

endmodule