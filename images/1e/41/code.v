module instruction_pipeline(  
    input clk,  
    input rst,  
    input [7:0] instruction,  
    output reg [7:0] fetched_instruction,  
    output reg [7:0] decoded_instruction,  
    output reg [7:0] executed_instruction,  
    output reg valid  
);  

    reg [1:0] state;  
    parameter IF = 2'b00, ID = 2'b01, EX = 2'b10;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IF;  
            fetched_instruction <= 8'b0;  
            decoded_instruction <= 8'b0;  
            executed_instruction <= 8'b0;  
            valid <= 1'b0;  
        end else begin  
            case (state)  
                IF: begin  
                    fetched_instruction <= instruction;  
                    state <= ID;  
                end  
                ID: begin  
                    decoded_instruction <= fetched_instruction;  
                    state <= EX;  
                end  
                EX: begin  
                    executed_instruction <= decoded_instruction;  
                    valid <= 1'b1;  
                    state <= IF;  
                end  
                default: state <= IF;  
            endcase  
        end  
    end  
endmodule