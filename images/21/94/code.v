module pipeline_register (  
    input clk,  
    input [7:0] data_in,  
    output reg [7:0] data_out  
);  
    reg [7:0] stage [0:6];  
    
    always @(posedge clk) begin  
        stage[0] <= data_in;  
        stage[1] <= stage[0];  
        stage[2] <= stage[1];  
        stage[3] <= stage[2];  
        stage[4] <= stage[3];  
        stage[5] <= stage[4];  
        stage[6] <= stage[5];  
        data_out <= stage[6];  
    end  
endmodule