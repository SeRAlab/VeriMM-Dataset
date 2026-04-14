module CLK_DIV2 (
input       Reset,
input       IN,
output  reg OUT
);
always @ (posedge IN or posedge Reset)
    if (Reset)
        OUT     <=0;  
    else
        OUT     <=!OUT;    
endmodule