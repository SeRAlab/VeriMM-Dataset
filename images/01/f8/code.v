module fixed_priority_arbiter(  
    input clk,  
    input reset,  
    input [3:0] request,  
    output reg [3:0] grant  
);  
    reg [1:0] current_priority;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            grant <= 4'b0000;  
            current_priority <= 2'b00;  
        end else begin  
            grant <= 4'b0000;  
            case (current_priority)  
                2'b00: if (request[0]) grant[0] <= 1; else if (request[1]) grant[1] <= 1;  
                2'b01: if (request[1]) grant[1] <= 1; else if (request[2]) grant[2] <= 1;  
                2'b10: if (request[2]) grant[2] <= 1; else if (request[3]) grant[3] <= 1;  
                2'b11: if (request[3]) grant[3] <= 1; else if (request[0]) grant[0] <= 1;  
            endcase  
            current_priority <= current_priority + 1;  
        end  
    end  
endmodule