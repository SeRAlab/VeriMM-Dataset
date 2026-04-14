module fixed_priority_arbiter(  
    input clk,  
    input rst,  
    input [3:0] request,  
    output reg [3:0] grant  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            grant <= 4'b0000;  
        end else begin  
            grant <= 4'b0000;  
            if (request[0]) grant[0] <= 1;  
            else if (request[1]) grant[1] <= 1;  
            else if (request[2]) grant[2] <= 1;  
            else if (request[3]) grant[3] <= 1;  
        end  
    end  
endmodule