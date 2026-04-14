module CLK_SWITCH (   
input       IN_0,
input       IN_1,
input       SW  ,
output      OUT 
);
assign OUT=SW?IN_1:IN_0;
endmodule