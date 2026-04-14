module instruction_pipeline(clk, reset, instruction_in, hazard_detected, instruction_out);  
    input clk;  
    input reset;  
    input [4:0] instruction_in;  
    output reg hazard_detected;  
    output reg [4:0] instruction_out;  

    reg [4:0] fetch_stage;  
    reg [4:0] decode_stage;  
    reg [4:0] execute_stage;  
    reg [4:0] memory_stage;  
    reg [4:0] writeback_stage;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            fetch_stage <= 5'b0;  
            decode_stage <= 5'b0;  
            execute_stage <= 5'b0;  
            memory_stage <= 5'b0;  
            writeback_stage <= 5'b0;  
            hazard_detected <= 1'b0;  
            instruction_out <= 5'b0;  
        end else begin  
            // Pipeline logic with hazard detection  
            if (execute_stage == decode_stage) begin  
                hazard_detected <= 1'b1;  
            end else begin  
                hazard_detected <= 1'b0;  
            end  

            // Stages shift  
            writeback_stage <= memory_stage;  
            memory_stage <= execute_stage;  
            execute_stage <= decode_stage;  
            decode_stage <= fetch_stage;  
            fetch_stage <= instruction_in;  

            instruction_out <= writeback_stage;  
        end  
    end  
endmodule