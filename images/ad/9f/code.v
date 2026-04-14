module shift_reg16(din, clk, rst, dout);
    input din;
    input clk;
    input rst;
    output reg [15:0] dout;

    always @(posedge clk or posedge rst) begin
        if (rst)
            dout <= 16'b0;
        else
            dout <= {dout[14:0], din};
    end
endmodule