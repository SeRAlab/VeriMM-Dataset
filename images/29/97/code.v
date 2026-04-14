module pipeline_2stage (  
    input clk,  
    input [5:0] data_in,  
    output reg [5:0] data_out  
);  
    reg [5:0] stage1;  
    reg [5:0] stage2;  

    always @(posedge clk) begin  
        stage1 <= data_in + 1; // Addition in stage 1  
        stage2 <= stage1 - 1; // Subtraction in stage 2  
        data_out <= stage2;  
    end  
endmodule