module instruction_pipeline (  
    input wire clk,  
    input wire reset,  
    input wire valid,  
    input wire [31:0] instruction_in,  
    output reg [31:0] instruction_out,  
    output reg [7:0] opcode_out,  
    output reg [31:0] execution_out  
);  

    reg [31:0] if_id_instruction;  
    reg [7:0] id_ex_opcode;  
    reg [31:0] id_ex_instruction;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            instruction_out <= 32'b0;  
            opcode_out <= 8'b0;  
            execution_out <= 32'b0;  
            if_id_instruction <= 32'b0;  
            id_ex_opcode <= 8'b0;  
            id_ex_instruction <= 32'b0;  
        end else if (valid) begin  
            // Stage 1: Instruction Fetch  
            if_id_instruction <= instruction_in;  

            // Stage 2: Instruction Decode  
            opcode_out <= if_id_instruction[31:24];  
            id_ex_instruction <= if_id_instruction;  

            // Stage 3: Instruction Execute  
            execution_out <= id_ex_instruction + 32'd1;  // Simple execution example  
            instruction_out <= if_id_instruction;  
        end  
    end  
endmodule