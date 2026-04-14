module reg_16bit(
    input clk,
    input rst_n,
    input load,
    input [15:0] d,
    output reg [15:0] q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 16'b0;
    else if (load)
        q <= d;
end

endmodule