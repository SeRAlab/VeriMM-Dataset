module instruction_pipeline (  
    input clk,  
    input reset,  
    input [15:0] instruction_in,  
    input data_hazard,  
    input control_hazard,  
    output reg [15:0] instruction_out,  
    output reg [15:0] result_out  
);  

    reg [15:0] if_reg, id_reg, ex_reg, mem_reg;  
    reg stall;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            if_reg <= 16'b0;  
            id_reg <= 16'b0;  
            ex_reg <= 16'b0;  
            mem_reg <= 16'b0;  
            instruction_out <= 16'b0;  
            result_out <= 16'b0;  
            stall <= 1'b0;  
        end else begin  
            if (stall) begin  
                // Maintain current state if stalled  
                instruction_out <= instruction_out;  
                result_out <= result_out;  
            end else begin  
                // Pipeline stages  
                if (data_hazard) begin  
                    stall <= 1'b1;  
                end else if (control_hazard) begin  
                    // Handle control hazard  
                    id_reg <= instruction_in;  
                    stall <= 1'b1;  
                end else begin  
                    // Update pipeline stages  
                    if_reg <= instruction_in;  
                    id_reg <= if_reg;  
                    ex_reg <= id_reg;  
                    mem_reg <= ex_reg;  
                    instruction_out <= id_reg; // Output from Decode stage  
                    result_out <= mem_reg; // Output from Write Back stage  
                end  
            end  
        end  
    end  
endmodule