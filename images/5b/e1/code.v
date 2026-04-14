module top_module(
    input  SaltoCond,
	input Saltoincond,
	input [31:0] extSigno, 
	input oZero,
    input clk,
    input reset,
	input [31:0]instru,
    output reg [31:0] direinstru
    );wire [31:0] sum2sum;
    wire [31:0] salSum2;
	wire FuentePC; 
	wire [31:0] sal2PC;
	wire [31:0] mux2mux;
	

    parameter init = 0;
    
    
  
    assign salSum2 =  extSigno + sum2sum;
    assign sum2sum = direinstru +1;
    assign sal2PC = (Saltoincond)? {sum2sum[31:28],instru[27:0]} : mux2mux;
    assign FuentePC = SaltoCond & oZero;
	assign mux2mux = FuentePC ? salSum2 : sum2sum;
	
	

    
    
    
   
 
    always @(posedge clk)
        begin
           
           if (reset==1)
                direinstru = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
                
           else

                    direinstru = sal2PC;
       
                
            

    

        
        end
            
    endmodule