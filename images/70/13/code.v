module top_module(
    addr,
    dout
);input [3:0] addr;
output [3:0] dout;
reg [3:0] dout;




always @(addr) begin: ROMPARMLOAD_READACTION
    case (addr)
        0: dout = 3;
        1: dout = 2;
        2: dout = 1;
        default: dout = 0;
    endcase
end

endmodule