module shift_reg_4bit(
    input clk,
    input rst_n,
    input load,
    input [3:0] data_in,
    output reg [3:0] q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 4'd0;
    else if (load)
        q <= data_in;
    else
        q <= {q[2:0], 1'b0};
end

endmodule