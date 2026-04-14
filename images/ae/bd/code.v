module top_module(ctr,i_16,o_32
    );input wire ctr;
input wire [15:0] i_16;
output wire [31:0] o_32;
assign o_32=(i_16[15]==1'b1 && ctr==1)?{16'b1111_1111_1111_1111,i_16}:{16'b0000_0000_0000_0000,i_16};


endmodule