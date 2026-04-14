module Eblock(
    input [0:31] R,
    output [0:47] Rout
    );
    
    assign Rout = {R[31], R[0:30]} << 1;
    
endmodule