module pipeline_2stage (  
    input clk,  
    input [7:0] data_in,  
    output reg [8:0] data_out  
);  

    reg [8:0] stage1_out;  

    // Stage 1: Double the input  
    always @(posedge clk) begin  
        stage1_out <= data_in * 2;  
    end  

    // Stage 2: Add 5 to the output of Stage 1  
    always @(posedge clk) begin  
        data_out <= stage1_out + 5;  
    end  
endmodule