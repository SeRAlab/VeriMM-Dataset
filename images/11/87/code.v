module instruction_pipeline (  
    input clk,  
    input rst,  
    input [15:0] instruction_in,  
    output reg [15:0] fetched,  
    output reg [15:0] decoded,  
    output reg [15:0] executed  
);  
    reg [15:0] stage1, stage2, stage3;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            fetched <= 16'b0;  
            decoded <= 16'b0;  
            executed <= 16'b0;  
            stage1 <= 16'b0;  
            stage2 <= 16'b0;  
            stage3 <= 16'b0;  
        end else begin  
            stage1 <= instruction_in;  
            fetched <= stage1;  
            stage2 <= fetched;  
            decoded <= stage2;  
            stage3 <= decoded;  
            executed <= stage3;  
        end  
    end  
endmodule