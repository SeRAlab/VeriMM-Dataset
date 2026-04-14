module top_module(dataOut, sel, andOut, orOut, FAOut, sltOut );output dataOut;
    input andOut, orOut, FAOut, sltOut;
    input [5:0] sel;
    
    assign dataOut = sel[2] ? ( sel[0] ? orOut : andOut ) : ( sel[3] ? sltOut : FAOut);
    
endmodule