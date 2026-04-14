module top_module(input clk, reset,set,
                      input clk_en,
                      input [3:0] data_in, 
                      output reg data_out);always @(posedge clk or posedge reset) 
        if(reset) 
            data_out <= 1'b0;
        else if(clk_en) 
            data_out <= &data_in;
        else            
            data_out <= data_out;endmodule