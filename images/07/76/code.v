module round_robin_arbiter(  
    input wire clk,  
    input wire reset,  
    input wire [3:0] request,  
    output reg [3:0] grant  
);  

    reg [1:0] pointer;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            grant <= 4'b0000;  
            pointer <= 2'b00;  
        end else begin  
            if (request != 4'b0000) begin  
                grant <= 4'b0000;  
                grant[pointer] <= 1'b1;  
                pointer <= (pointer + 1) % 4;  
            end else begin  
                grant <= 4'b0000;  
            end  
        end  
    end  
endmodule