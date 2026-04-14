module top_module( rst, addr, dout );input rst;
    input [11:2] addr;
    output [31:0] dout;
        
    reg [31:0] imem[1023:0];
    
    
    assign dout = imem[addr];
endmodule