module top_module(
    dout,
    addr
);output [7:0] dout;
reg [7:0] dout;
input [3:0] addr;






always @(addr) begin: ROM_READ
    case (addr)
        0: dout = 17;
        1: dout = 134;
        2: dout = 52;
        default: dout = 9;
    endcase
end

endmodule