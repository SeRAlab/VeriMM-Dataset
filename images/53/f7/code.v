module top_module(
    output[15:0] dataBus,
    input RD,
    input E_PC,
    input E_SP,
    input E_IP,
    input E_OR,
    input E_R0,
    input E_RN,
    input [15:0] pcOut,
    input [15:0] memOut,
    input [15:0] orOut,
    input [15:0] spOut,
    input [15:0] raOut,
    input [15:0] ioOut
    );assign dataBus = (RD)? memOut :(
                    (E_PC)? pcOut :( 
                    (E_SP)? spOut :( 
                    (E_IP)? ioOut :(
                    (E_OR)? orOut :(
                    ( E_R0 | E_RN )? raOut :
                     16'h0000))))); 
           
endmodule