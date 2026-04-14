module pipelined_adder (  
    input clk,  
    input reset,  
    input [7:0] operand_a,  
    input [7:0] operand_b,  
    output reg [7:0] result  
);  

    reg [7:0] if_operand_a, if_operand_b;  
    reg [7:0] id_operand_a, id_operand_b;  
    reg [7:0] ex_operand_a, ex_operand_b;  
    reg [7:0] mem_result;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            if_operand_a <= 0;  
            if_operand_b <= 0;  
            id_operand_a <= 0;  
            id_operand_b <= 0;  
            ex_operand_a <= 0;  
            ex_operand_b <= 0;  
            mem_result <= 0;  
            result <= 0;  
        end else begin  
            // Instruction Fetch Stage  
            if_operand_a <= operand_a;  
            if_operand_b <= operand_b;  

            // Instruction Decode Stage  
            id_operand_a <= if_operand_a;  
            id_operand_b <= if_operand_b;  

            // Execute Stage  
            ex_operand_a <= id_operand_a;  
            ex_operand_b <= id_operand_b;  
            mem_result <= ex_operand_a + ex_operand_b;  

            // Memory Access Stage  
            result <= mem_result;  
        end  
    end  
endmodule