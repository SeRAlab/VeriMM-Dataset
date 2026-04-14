module pipeline_2stage (  
    input clk,  
    input [3:0] data_in,  
    output reg [3:0] data_out  
);  
    reg [3:0] stage1;  

    always @(posedge clk) begin  
        stage1 <= data_in + 1;  
        data_out <= stage1 + 1;  
    end  
endmodule