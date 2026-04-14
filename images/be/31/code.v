module d_flip_flop(
    input clk,
    input rst,
    input [3:0] d,
    output reg [3:0] q
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 4'b0000;
        end else begin
            q <= d;
        end
    end
endmodule