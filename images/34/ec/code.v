module down_counter(  
    input clk,  
    input reset_n,  
    input enable,  
    output reg [3:0] count  
);  
    always @(posedge clk or negedge reset_n) begin  
        if (!reset_n) begin  
            count <= 4'b1111;  // Reset to 15  
        end else if (enable) begin  
            if (count > 0)  
                count <= count - 1;  
        end  
    end  
endmodule