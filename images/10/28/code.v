module pipelined_processor (  
    input clk,  
    input reset,  
    input [7:0] data_in,  
    input [1:0] op,  
    output reg [15:0] result  
);  
    reg [7:0] stage_reg [0:6];  
    reg [1:0] op_reg [0:6];  
    integer i;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            for (i = 0; i < 7; i = i + 1) begin  
                stage_reg[i] <= 0;  
                op_reg[i] <= 0;  
            end  
            result <= 0;  
        end else begin  
            stage_reg[0] <= data_in;  
            op_reg[0] <= op;  
            for (i = 1; i < 7; i = i + 1) begin  
                stage_reg[i] <= stage_reg[i-1];  
                op_reg[i] <= op_reg[i-1];  
            end  
            case (op_reg[6])  
                2'b00: result <= stage_reg[6] + stage_reg[5]; // Addition  
                2'b01: result <= stage_reg[6] - stage_reg[5]; // Subtraction  
                2'b10: result <= stage_reg[6] * stage_reg[5]; // Multiplication  
                2'b11: result <= stage_reg[6] / stage_reg[5]; // Division  
                default: result <= 0;  
            endcase  
        end  
    end  
endmodule