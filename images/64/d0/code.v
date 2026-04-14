module top_module(
    input [19:0] numeros,
    output [15:0] operador

    );localparam exp4= 16'd10000;
    localparam exp3= 16'd1000;
    localparam exp2= 16'd100;
    localparam exp1= 16'd10;
    localparam exp0= 16'd1;
    
    wire [15:0] num_exp4,num_exp3,num_exp2,num_exp1,num_exp0;
    
    assign num_exp4={12'b0,numeros[19:16]}*exp4;
    assign num_exp3={12'b0,numeros[15:12]}*exp3;
    assign num_exp2={12'b0,numeros[11:8]}*exp2;
    assign num_exp1={12'b0,numeros[7:4]}*exp1;
    assign num_exp0={12'b0,numeros[3:0]}*exp0;
    
    assign operador=num_exp0+num_exp1+num_exp2+num_exp3+num_exp4;
    
endmodule