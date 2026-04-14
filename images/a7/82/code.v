module top_module(
    addr,
    dout
);input [3:0] addr;
output [3:0] dout;
reg [3:0] dout;




always @(addr) begin: ROMLOADED_READACTION
    case (addr)
        'h0: begin
            dout = 3;
        end
        'h1: begin
            dout = 2;
        end
        'h2: begin
            dout = 1;
        end
        'h3: begin
            dout = 0;
        end
    endcase
end

endmodule