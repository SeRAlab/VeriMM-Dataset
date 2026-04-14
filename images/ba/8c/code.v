module reg_4bit(
    input clk,
    input rst,
    input en,
    input [3:0] d,
    output reg [3:0] q
);

always @(posedge clk or posedge rst) begin
    if (rst)
        q <= 4'b0;
    else if (en)
        q <= d;
end

endmodule