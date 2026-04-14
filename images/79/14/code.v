module top_module(aluf,readAddrA,readAddrB, writeAddress,selA,selB,clrR,
             clrIr0, gate, rw, sel_addr_reg, dojump, wrAddr,
             ir0q,ir1q,flags,reset);output [3:0] aluf,readAddrA,readAddrB, writeAddress;
output [1:0] selA,selB;
output clrR, clrIr0, gate, rw, sel_addr_reg, dojump,wrAddr ;
input [15:0] ir0q,ir1q;
input [3:0] flags;
input reset;



wire m0 = ir0q[3],
     m1 = ir1q[3];


`define unc     3'b000
`define pos     3'b001
`define neg     3'b010
`define zero    3'b011
`define parodd  3'b100
`define carry   3'b101
`define ncarry  3'b110
`define nzero   3'b111
 
function jmpchk;
input [2:0] condition;
input [3:0] flags;
reg sign,carry,parity,zero;
begin
        {sign,carry,parity,zero} = flags;
        case (condition)
        `unc:   jmpchk = 1;
        `pos:   jmpchk = ~ sign;
        `neg:   jmpchk = sign;
        `zero:  jmpchk = zero;
        `parodd: jmpchk = parity;
        `carry: jmpchk = carry;
        `ncarry: jmpchk = ~carry;
        `nzero: jmpchk = ~zero;
        endcase
end
endfunction

assign #1 

        aluf = ir1q[15:12],


        readAddrA = ir0q[11:8],
        readAddrB = ir0q[ 7:4],


        writeAddress = ir1q[11:8],


	selA = readAddrA[3:2] ? 2'b11 : readAddrA[1:0],
	selB = readAddrB[3:2] ? 2'b11 : readAddrB[1:0],



        sel_addr_reg = (m0 & (ir0q[ 7:4] == 4'b0)) 
                     | (m1 & (ir1q[11:8] == 4'b0)) ,



        rw = ~(m1 & (ir1q[11:8] == 4'b0)) ,


        dojump = jmpchk(ir1q[2:0],flags) & (ir1q[11:8] == 3'h1),


	wrAddr = (ir1q[11:8] == 3'h2),

        gate = | ir1q[15:12] ,


        clrR = reset,



        clrIr0 = reset | dojump 
                 | ((ir0q[ 7:4] == 4'b0) & (ir0q[ 11:8] != 4'b0))
                 | ~rw ;

endmodule