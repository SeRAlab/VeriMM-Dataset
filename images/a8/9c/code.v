module shift_register (
    input wire rst_n,
    input wire clk,
    input wire dir,
    input wire din,
    output reg [3:0] dout
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        dout <= 4'b0000;
    else if (dir)
        dout <= {din, dout[3:1]};
    else
        dout <= {dout[2:0], din};
end

endmodule