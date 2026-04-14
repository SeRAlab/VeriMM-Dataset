module top_module(
    output reg[17:1]  OUT,
    input  wire[11:0]  IN
);assign OUT = {
        IN[11], 
        PAR[4],   
        IN[10], 
        IN[9],  
        IN[8],  
        IN[7],  
        IN[6],  
        IN[5],  
        IN[4],  
        PAR[3],   
        IN[3],  
        IN[2],  
        IN[1],  
        PAR[2],   
        IN[0],  
        PAR[1],   
        PAR[0]    
    };

    
    reg[4:0] PAR;

    assign PAR[0]  = OUT[3]  ^ OUT[5]  ^ 
                     OUT[7]  ^ OUT[9]  ^ OUT[11] ^ 
                     OUT[13] ^ OUT[15] ^ OUT[17] ;

    assign PAR[1]  = OUT[3]  ^
                     OUT[6]  ^ OUT[7]  ^
                     OUT[10] ^ OUT[11] ^
                     OUT[14] ^ OUT[15];

    assign PAR[2]  = OUT[5]  ^ OUT[6]  ^ OUT[7]  ^
                     OUT[12] ^ OUT[13] ^ OUT[14] ^ OUT[15] ;

    assign PAR[3]  = OUT[9]  ^ OUT[10] ^ OUT[11] ^ OUT[12] ;

    assign PAR[4]  = OUT[17] ;

endmodule