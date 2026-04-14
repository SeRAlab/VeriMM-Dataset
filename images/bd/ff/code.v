module reg_16bit (
    input clk,
    input rst,
    input en,
    input [15:0] d,
    output reg [15:0] q
);

always @(posedge clk) begin
    if (rst)
        q <= 16'd0;
    else if (en)
        q <= d;
end

endmodule