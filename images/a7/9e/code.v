module top_module(
    input wire clk,
    input wire rst,
    
    
    input wire flush,

    
    input wire llE,
   
    output reg LLbit
    );always @ (posedge clk) begin
        LLbit <= rst | flush ? 1'b0 : 
                   llE ? 1'b1 : LLbit;
    end
endmodule