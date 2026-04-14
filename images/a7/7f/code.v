module shift_register(
    input clk,
    input rst_n,
    output reg [7:0] q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 8'b0;
    else
        q <= {1'b0, q[7:1]};
end

endmodule