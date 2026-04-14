module top_module(
    addr,
    dout,
    clk,
    rst
);input [3:0] addr;
output [3:0] dout;
reg [3:0] dout;
input clk;
input rst;




always @(posedge clk) begin: ROMPARMLOADSYNC_READACTION
    if (rst) begin
        dout <= 0;
    end
    else begin
        case (addr)
            0: dout <= 3;
            1: dout <= 2;
            2: dout <= 1;
            default: dout <= 0;
        endcase
    end
end

endmodule