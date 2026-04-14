module down_counter(  
    input clk,  
    input reset_n,  
    input enable,  
    input [3:0] N,  
    output reg [3:0] count  
);  
    always @(posedge clk or negedge reset_n) begin  
        if (!reset_n) begin  
            count <= N;  
        end else if (enable && count > 0) begin  
            count <= count - 1;  
        end  
    end  
endmodule