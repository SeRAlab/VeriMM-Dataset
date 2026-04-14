module pipeline_processor (  
    input clk,  
    input rst,  
    input [1:0] opcode_in,  
    input [2:0] reg_in,  
    output reg [1:0] opcode_out,  
    output reg [2:0] reg_out  
);  
    reg [1:0] stage_if;  
    reg [1:0] stage_id;  
    reg [1:0] stage_ex;  
    reg [1:0] stage_mem;  
    reg [1:0] stage_wb;  
    reg [2:0] reg_if;  
    reg [2:0] reg_id;  
    reg [2:0] reg_ex;  
    reg [2:0] reg_mem;  
    reg [2:0] reg_wb;  

    // Stage implementation  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            stage_if <= 0;  
            stage_id <= 0;  
            stage_ex <= 0;  
            stage_mem <= 0;  
            stage_wb <= 0;  
            reg_if <= 0;  
            reg_id <= 0;  
            reg_ex <= 0;  
            reg_mem <= 0;  
            reg_wb <= 0;  
        end else begin  
            // Stage IF  
            stage_if <= opcode_in;  
            reg_if <= reg_in;  
            
            // Stage ID  
            stage_id <= stage_if;  
            reg_id <= reg_if;  
            
            // Stage EX  
            stage_ex <= stage_id;  
            reg_ex <= reg_id;  
            
            // Stage MEM  
            stage_mem <= stage_ex;  
            reg_mem <= reg_ex;  
            
            // Stage WB  
            stage_wb <= stage_mem;  
            reg_wb <= reg_mem;  

            // Outputs  
            opcode_out <= stage_wb;  
            reg_out <= reg_wb;  
        end  
    end  
endmodule