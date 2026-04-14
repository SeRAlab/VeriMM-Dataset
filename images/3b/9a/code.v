module instruction_pipeline(  
    input clk,  
    input [4:0] instruction,  
    output reg [4:0] stage_output,  
    output reg [1:0] stage_id  
);  

    reg [4:0] if_reg;  
    reg [4:0] id_reg;  
    reg [4:0] ex_reg;  

    always @(posedge clk) begin  
        // Move instructions through stages  
        ex_reg <= id_reg;  
        id_reg <= if_reg;  
        if_reg <= instruction;  
    end  

    always @(*) begin  
        // Set output based on current stage  
        case(stage_id)  
            2'b00: stage_output = if_reg;  
            2'b01: stage_output = id_reg;  
            2'b10: stage_output = ex_reg;  
            default: stage_output = 5'b00000;  
        endcase  
    end  
endmodule