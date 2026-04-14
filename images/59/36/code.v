module top_module(datain, dataout, clk);input datain; 
    output dataout; 
    wire dataout;
    input clk; 

    reg buff0; 
    reg buff1; 
    reg buff2; 

    assign dataout = buff2 ;

    always @(posedge clk)
    begin

       buff0 <= datain ; 
		buff1 <= buff0;
		buff2 <= buff1;
    end 
 endmodule