module pipelined_cpu (  
    input clk,  
    input reset,  
    input [7:0] instruction_in,  
    output reg [7:0] reg_out  
);  

    reg [7:0] IF_ID_instruction;  
    reg [7:0] ID_EX_A, ID_EX_B;  
    reg [7:0] EX_MEM_result;  
    reg [7:0] WB_data;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            IF_ID_instruction <= 8'b0;  
            ID_EX_A <= 8'b0;  
            ID_EX_B <= 8'b0;  
            EX_MEM_result <= 8'b0;  
            WB_data <= 8'b0;  
            reg_out <= 8'b0;  
        end else begin  
            // Stage 1: Instruction Fetch  
            IF_ID_instruction <= instruction_in;  

            // Stage 2: Instruction Decode  
            ID_EX_A <= IF_ID_instruction[3:0]; // Source Register 1  
            ID_EX_B <= IF_ID_instruction[7:4]; // Source Register 2  

            // Stage 3: Execute  
            EX_MEM_result <= ID_EX_A + ID_EX_B;  

            // Stage 4: Memory Access (No Memory in this case, skip)  

            // Stage 5: Write Back  
            reg_out <= EX_MEM_result;  
        end  
    end  
endmodule