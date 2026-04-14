module up_down_counter(  
    input clk,  
    input rst,  
    input enable,  
    input up_down,  // 1 for up, 0 for down  
    output reg [15:0] count  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            count <= 16'b0;  
        end else if (enable) begin  
            if (up_down) begin  
                count <= count + 1'b1; // Increment  
            end else begin  
                count <= count - 1'b1; // Decrement  
            end  
        end  
    end  
endmodule