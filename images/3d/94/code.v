module round_robin_arbiter(  
    input clk,  
    input rst,  
    input [3:0] req,  
    output reg [3:0] grant  
);  
    reg [1:0] ptr; // Pointer for round-robin selection  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            grant <= 4'b0000;  
            ptr <= 2'b00;  
        end else begin  
            grant <= 4'b0000; // Reset grant  
            if (req != 4'b0000) begin  
                grant[ptr] <= 1'b1; // Grant the current pointer  
                ptr <= (ptr + 1) % 4; // Move pointer in a round-robin fashion  
            end  
        end  
    end  
endmodule