module pipeline_unit (  
    input clk,  
    input reset,  
    input [7:0] instruction,  
    output reg [7:0] result  
);  
    reg [7:0] IF_stage;  
    reg [7:0] ID_stage;  
    reg [7:0] EX_stage;  
    reg [7:0] MEM_stage;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            IF_stage <= 8'b0;  
            ID_stage <= 8'b0;  
            EX_stage <= 8'b0;  
            MEM_stage <= 8'b0;  
            result <= 8'b0;  
        end else begin  
            IF_stage <= instruction;  
            ID_stage <= IF_stage;  
            EX_stage <= ID_stage;  
            MEM_stage <= EX_stage;  
            result <= MEM_stage;  
        end  
    end  
endmodule