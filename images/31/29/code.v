module instruction_pipeline(  
    input clk,  
    input [3:0] instruction,  
    output reg [3:0] result  
);  
    reg [3:0] fetch_stage;  
    reg [3:0] decode_stage;  
    reg [3:0] execute_stage;  

    always @(posedge clk) begin  
        // Fetch Stage  
        fetch_stage <= instruction;  
        
        // Decode Stage  
        decode_stage <= fetch_stage;  
        
        // Execute Stage  
        execute_stage <= decode_stage;  
        // Here, we execute a simple operation based on the opcode  
        case (execute_stage[3:2])  
            2'b00: result <= execute_stage[1:0]; // No operation  
            2'b01: result <= execute_stage[1:0] + 1; // Increment  
            2'b10: result <= execute_stage[1:0] - 1; // Decrement  
            2'b11: result <= execute_stage[1:0] * 2; // Double  
            default: result <= 4'b0000;  
        endcase  
    end  
endmodule