module pipeline_2stage (  
    input [4:0] data_in,  
    input clk,  
    output reg [5:0] data_out  
);  
    reg [5:0] stage1_out;  

    always @(posedge clk) begin  
        // Stage 1: Addition  
        stage1_out <= data_in + 5'b00001;  
    end  

    always @(posedge clk) begin  
        // Stage 2: Multiplication by 3  
        data_out <= stage1_out * 6'd3;  
    end  
endmodule