module instruction_pipeline (  
    input clk,  
    input reset,  
    input [31:0] instruction,  
    output reg [31:0] result  
);  
    reg [31:0] pc;  
    reg [31:0] if_id_instr;  
    reg [31:0] id_ex_instr;  
    reg [31:0] ex_mem_instr;  
    reg [31:0] mem_wb_instr;  
    reg hazard_detected;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            pc <= 0;  
            if_id_instr <= 0;  
            id_ex_instr <= 0;  
            ex_mem_instr <= 0;  
            mem_wb_instr <= 0;  
            result <= 0;  
            hazard_detected <= 0;  
        end else begin  
            // Fetch stage  
            if (!hazard_detected) begin  
                if_id_instr <= instruction;  
                pc <= pc + 4;  
            end
            
            // Decode stage  
            id_ex_instr <= if_id_instr;  

            // Execute stage  
            ex_mem_instr <= id_ex_instr;  
            result <= ex_mem_instr + 1; // Dummy operation for demonstration  

            // Memory stage  
            mem_wb_instr <= ex_mem_instr;  
        end  
    end  
endmodule