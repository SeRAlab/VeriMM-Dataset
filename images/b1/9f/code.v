module top_module(addr_in,addr_out);input [31:0] addr_in;
    output [31:0] addr_out;
        assign addr_out=(addr_in-32'h10010000)>>2;
   
endmodule