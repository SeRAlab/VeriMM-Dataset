module pipeline_processor (  
    input clk,  
    input [4:0] data_in,  
    output reg [4:0] data_out  
);  
    reg [4:0] stage [0:6];  
    integer i;  

    always @(posedge clk) begin  
        stage[0] <= data_in + 5'd3;  
        for (i = 1; i < 7; i = i + 1) begin  
            stage[i] <= stage[i-1];  
        end  
        data_out <= stage[6];  
    end  
endmodule