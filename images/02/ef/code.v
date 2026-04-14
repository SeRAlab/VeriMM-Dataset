module pipeline_processor(  
    input clk,  
    input reset,  
    input [4:0] data_in,  
    output reg [4:0] data_out  
);  
    reg [4:0] stage [0:6];  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 5'b0;  
            stage[0] <= 5'b0;  
            stage[1] <= 5'b0;  
            stage[2] <= 5'b0;  
            stage[3] <= 5'b0;  
            stage[4] <= 5'b0;  
            stage[5] <= 5'b0;  
            stage[6] <= 5'b0;  
        end else begin  
            stage[0] <= data_in;  
            stage[1] <= stage[0] + 1;  
            stage[2] <= stage[1] << 1;  
            stage[3] <= stage[2] ^ 5'b10101;  
            stage[4] <= stage[3] - 1;  
            stage[5] <= stage[4] >> 1;  
            stage[6] <= stage[5];  
            data_out <= stage[6];  
        end  
    end  
endmodule