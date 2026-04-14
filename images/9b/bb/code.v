module top_module(datain, dataout, clk);input[51 - 1:0] datain; 
    output[51 - 1:0] dataout; 
    wire[51 - 1:0] dataout;
    input clk; 

    reg[51 - 1:0] buff0; 

    assign dataout = buff0 ;

    always @(posedge clk)
    begin

       buff0 <= datain ; 
    end 
 endmodule