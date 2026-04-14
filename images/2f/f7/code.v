module pipelined_processor(  
    input clk,  
    input reset,  
    input [15:0] instruction_in,  
    output [15:0] instruction_out  
);  
    reg [15:0] IF_ID, ID_EX, EX_MEM, MEM_WB;  
    reg [3:0] registers [0:3]; // 4 registers  
    wire [15:0] instruction;  
   
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            IF_ID <= 0;  
            ID_EX <= 0;  
            EX_MEM <= 0;  
            MEM_WB <= 0;  
        end else begin  
            // Pipeline flow  
            IF_ID <= instruction_in;  
            ID_EX <= IF_ID;  
            EX_MEM <= ID_EX;  
            MEM_WB <= EX_MEM;  
        end  
    end  
   
    assign instruction_out = MEM_WB;  
endmodule