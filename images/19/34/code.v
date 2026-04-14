module pipeline_processor(  
    input clk,  
    input [3:0] data_in,  
    output reg [3:0] data_out  
);  
    reg [3:0] stage1;  

    // Stage 1: Increment the input  
    always @(posedge clk) begin  
        stage1 <= data_in + 1;  
    end  

    // Stage 2: AND with fixed value (4'b1010)  
    always @(posedge clk) begin  
        data_out <= stage1 & 4'b1010;  
    end  
endmodule