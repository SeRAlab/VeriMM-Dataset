module instruction_pipeline (  
    input wire clk,  
    input wire reset,  
    input wire [15:0] instruction_in,  
    output reg [15:0] instruction_if,  
    output reg [15:0] instruction_id,  
    output reg [15:0] instruction_ex  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            instruction_if <= 16'b0;  
            instruction_id <= 16'b0;  
            instruction_ex <= 16'b0;  
        end else begin  
            instruction_if <= instruction_in;  
            instruction_id <= instruction_if;  
            instruction_ex <= instruction_id;  
        end  
    end  
endmodule