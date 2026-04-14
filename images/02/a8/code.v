module pipeline(clk, reset, instruction_in, instruction_out);  
    input clk;  
    input reset;  
    input [31:0] instruction_in;  
    output reg [31:0] instruction_out;  
    reg [31:0] IF_ID, ID_EX, EX_MEM, MEM_WB;  
    reg stall;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            IF_ID <= 32'b0;  
            ID_EX <= 32'b0;  
            EX_MEM <= 32'b0;  
            MEM_WB <= 32'b0;  
            instruction_out <= 32'b0;  
            stall <= 1'b0;  
        end else begin  
            if (!stall) begin  
                IF_ID <= instruction_in;  
                ID_EX <= IF_ID;  
                EX_MEM <= ID_EX;  
                MEM_WB <= EX_MEM;  
                instruction_out <= MEM_WB;  
            end  
            // Simple stall condition simulation
            if (ID_EX[31:28] == 4'b1111)  // arbitrary condition for stall  
                stall <= 1'b1;  
            else  
                stall <= 1'b0;  
        end  
    end  
endmodule