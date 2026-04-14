module top_module(input clk, sreset,
                     input clk_en,
                     input [5:0] data_in1,data_in2, 
                     output reg data_out1,data_out2);always @(posedge clk)  
        if(sreset) 
            data_out1 <= 1'b0;
        else
            data_out1 <= clk_en ? &data_in1 : data_out1;

    always @(posedge clk)  
        if(sreset) 
            data_out2 <= 1'b0;
        else            
            data_out2 <= clk_en ? &data_in2 : data_out2;endmodule