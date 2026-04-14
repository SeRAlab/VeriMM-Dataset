module pipeline_processor (  
    input clk,  
    input rst,  
    input [7:0] operand_a,  
    input [7:0] operand_b,  
    input [1:0] opcode,  // 00 for ADD, 01 for SUB  
    output reg [7:0] result,  
    output reg valid  
);  
    reg [7:0] if_register_a, if_register_b;  
    reg [1:0] id_opcode;  
    reg [7:0] ex_result;  
    reg [7:0] mem_data;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            if_register_a <= 8'b0;  
            if_register_b <= 8'b0;  
            id_opcode <= 2'b0;  
            ex_result <= 8'b0;  
            mem_data <= 8'b0;  
            result <= 8'b0;  
            valid <= 1'b0;  
        end else begin  
            // IF Stage  
            if_register_a <= operand_a;  
            if_register_b <= operand_b;  
            id_opcode <= opcode;  

            // ID Stage   
            if (id_opcode == 2'b00) begin  
                ex_result <= if_register_a + if_register_b;  
            end else if (id_opcode == 2'b01) begin  
                ex_result <= if_register_a - if_register_b;  
            end  

            // MEM Stage  
            mem_data <= ex_result;  

            // WB Stage  
            result <= mem_data;  
            valid <= 1'b1;  
        end  
    end  
endmodule