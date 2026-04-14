module fixed_priority_arbiter(  
    input wire clk,  
    input wire rst,  
    input wire [3:0] req,  
    output reg [3:0] grant  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            grant <= 4'b0000;  
        end else begin  
            grant <= 4'b0000;  
            if (req[3]) begin  
                grant[3] <= 1;  
            end else if (req[2]) begin  
                grant[2] <= 1;  
            end else if (req[1]) begin  
                grant[1] <= 1;  
            end else if (req[0]) begin  
                grant[0] <= 1;  
            end  
        end  
    end  
endmodule