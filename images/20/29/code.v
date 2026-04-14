module fixed_priority_arbiter(  
    input clk,  
    input rst,  
    input req0,  
    input req1,  
    input req2,  
    input req3,  
    output reg [3:0] grant  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            grant <= 4'b0000;  
        end else begin  
            grant <= 4'b0000;  
            if (req0) begin  
                grant <= 4'b0001;  
            end else if (req1) begin  
                grant <= 4'b0010;  
            end else if (req2) begin  
                grant <= 4'b0100;  
            end else if (req3) begin  
                grant <= 4'b1000;  
            end  
        end  
    end  
endmodule