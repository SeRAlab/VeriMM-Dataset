module shift_register(
    input wire clk,
    input wire rst_n,
    input wire en,
    input wire din,
    output reg [3:0] q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 4'd0;
    else if (en)
        q <= {q[2:0], din};
end

endmodule