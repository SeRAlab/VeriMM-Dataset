module round_robin_arbiter (  
    input wire clk,  
    input wire rst,  
    input wire [3:0] req,  
    output reg [3:0] grant  
);  
    reg [1:0] pointer;  
    reg [3:0] req_mask;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            grant <= 4'b0000;  
            pointer <= 2'b00;  
        end else begin  
            req_mask = req & (4'b0001 << pointer);  
            if (req_mask != 4'b0000) begin  
                grant <= req_mask;  
                pointer <= (pointer + 1) % 4;  
            end else begin  
                grant <= 4'b0000;  
                pointer <= (pointer + 1) % 4;  
            end  
        end  
    end  
endmodule