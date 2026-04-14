module pipeline_processor (  
    input [3:0] A,  
    input [3:0] B,  
    input op,  
    input clk,  
    output reg [3:0] result  
);  
    reg [3:0] stage1_result;  
    always @(posedge clk) begin  
        if (op == 0) begin  
            stage1_result <= A + B;  
        end else begin  
            stage1_result <= A - B;  
        end  
    end  

    always @(posedge clk) begin  
        result <= stage1_result;  
    end  
endmodule