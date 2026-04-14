module bidirectional_shift_reg(
    input wire clk,
    input wire rst_n,
    input wire din,
    input wire shift_left,
    input wire shift_right,
    output reg [7:0] dout
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        dout <= 8'b0;
    end else if (shift_left) begin
        dout <= {dout[6:0], din};
    end else if (shift_right) begin
        dout <= {din, dout[7:1]};
    end
end

endmodule