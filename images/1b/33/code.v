module pipelined_processor (  
    input clk,  
    input rst,  
    input [7:0] a,  
    input [7:0] b,  
    output reg [7:0] result  
);  
    reg [7:0] IF_ID_a, IF_ID_b;  
    reg [7:0] ID_EX_a, ID_EX_b;  
    reg [7:0] EX_MEM_sum;  
    reg [7:0] MEM_WB_result;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            IF_ID_a <= 0;  
            IF_ID_b <= 0;  
            ID_EX_a <= 0;  
            ID_EX_b <= 0;  
            EX_MEM_sum <= 0;  
            MEM_WB_result <= 0;  
            result <= 0;  
        end else begin  
            // Stage 1: Instruction Fetch  
            IF_ID_a <= a;  
            IF_ID_b <= b;  

            // Stage 2: Instruction Decode  
            ID_EX_a <= IF_ID_a;  
            ID_EX_b <= IF_ID_b;  

            // Stage 3: Execute  
            EX_MEM_sum <= ID_EX_a + ID_EX_b;  

            // Stage 4: Memory Access (no memory in this case, just a pass-through)  
            MEM_WB_result <= EX_MEM_sum;  

            // Stage 5: Write Back  
            result <= MEM_WB_result;  
        end  
    end  
endmodule