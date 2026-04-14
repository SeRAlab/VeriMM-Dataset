module top_module(IP, IC, IS0, IZ);(* CLOCK *)
    input  wire IP;

    
    (* CLOCK *)
    input  wire IC;

    
    input  wire IS0;

    
    (* DELAY_CONST_IP="1e-10" *)
    (* DELAY_CONST_IC="2e-10" *)
    (* DELAY_CONST_IS0="3e-10" *)
    (* COMB_INCLUDE_CLOCKS *)
    output wire IZ;

    
    assign IZ = IS0 ? IC : IP;

endmodule