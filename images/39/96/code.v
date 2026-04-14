module pipelined_processor (  
    input clk,  
    input rst,  
    input [7:0] data_a,  
    input [7:0] data_b,  
    output reg [7:0] result  
);  

    reg [7:0] IF_ID_inst_a, IF_ID_inst_b;  
    reg [7:0] ID_EX_a, ID_EX_b;  
    reg [7:0] EX_MEM_result;  
    reg [7:0] MEM_WB_result;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            IF_ID_inst_a <= 8'b0;  
            IF_ID_inst_b <= 8'b0;  
            ID_EX_a <= 8'b0;  
            ID_EX_b <= 8'b0;  
            EX_MEM_result <= 8'b0;  
            MEM_WB_result <= 8'b0;  
            result <= 8'b0;  
        end else begin  
            // Stage IF  
            IF_ID_inst_a <= data_a;  
            IF_ID_inst_b <= data_b;  

            // Stage ID  
            ID_EX_a <= IF_ID_inst_a;  
            ID_EX_b <= IF_ID_inst_b;  

            // Stage EX  
            EX_MEM_result <= ID_EX_a + ID_EX_b;  

            // Stage MEM  
            MEM_WB_result <= EX_MEM_result;  

            // Stage WB  
            result <= MEM_WB_result;  
        end  
    end  
endmodule