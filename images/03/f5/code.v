module instruction_pipeline(  
    input clk,  
    input rst,  
    input [1:0] stage, // 00: fetch, 01: decode, 10: execute  
    output reg done  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            done <= 0;  
        end else begin  
            case (stage)  
                2'b00: done <= 0; // Fetch stage  
                2'b01: done <= 0; // Decode stage  
                2'b10: done <= 1; // Execute stage  
                default: done <= 0;  
            endcase  
        end  
    end  
endmodule