module M65C02_BIN(
    input   En,                 
    input   [7:0] A,            
    input   [7:0] B,            
    input   Ci,                 
    output  reg [8:0] Out,      
    output  reg OV,             
    output  reg Valid           
);
reg     [7:0] S;        
reg     C6, C7;         
always @(*)
begin
    {C6, S[6:0]} <= ({1'b0, A[6:0]} + {1'b0, B[6:0]} + {7'b0, Ci});
    {C7,   S[7]} <= ({1'b0,   A[7]} + {1'b0,   B[7]} + {1'b0, C6});
end
always @(*)
begin
    Out   <= ((En) ? {C7, S}   : 0);
    OV    <= ((En) ? (C7 ^ C6) : 0);
    Valid <= En;
end
endmodule