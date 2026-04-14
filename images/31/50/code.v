module pipeline_2stage (  
    input clk,  
    input reset,  
    input [7:0] data_in,  
    output reg [15:0] data_out  
);  
    reg [7:0] stage1;  
    reg [15:0] stage2;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            stage1 <= 0;  
            stage2 <= 0;  
            data_out <= 0;  
        end else begin  
            stage1 <= data_in + 8'd10; // Stage 1: Add 10  
            stage2 <= stage1 * 8'd2;    // Stage 2: Multiply by 2  
            data_out <= stage2;  
        end  
    end  
endmodule