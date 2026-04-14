module pipeline_processor(  
    input clk,  
    input [7:0] in_data,  
    output reg [7:0] out_data  
);  
    reg [7:0] stage1_reg;  

    always @(posedge clk) begin  
        stage1_reg <= in_data + 1; // Stage 1: Increment  
        out_data <= stage1_reg * 2; // Stage 2: Multiply by 2  
    end  
endmodule