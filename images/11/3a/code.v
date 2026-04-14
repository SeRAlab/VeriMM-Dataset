module instruction_pipeline(  
    input clk,  
    input rst,  
    input [4:0] instruction_in,  
    output reg [4:0] instruction_out,  
    output reg [1:0] stage  
);  

    // State definitions  
    parameter FETCH = 2'b00, DECODE = 2'b01, EXECUTE = 2'b10;  
    reg [1:0] current_stage;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            current_stage <= FETCH;  
            instruction_out <= 5'b0;  
        end else begin  
            case (current_stage)  
                FETCH: begin  
                    instruction_out <= instruction_in;  
                    current_stage <= DECODE;  
                end  
                DECODE: begin  
                    // Here we just pass the instruction, in a real case we would decode it.  
                    current_stage <= EXECUTE;  
                end  
                EXECUTE: begin  
                    // In a real case we would execute the instruction.  
                    current_stage <= FETCH;  
                end  
            endcase  
        end  
    end  

    always @(current_stage) begin  
        stage <= current_stage;  
    end  
endmodule