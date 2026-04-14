module round_robin_arbiter(  
    input clk,  
    input rst,  
    input [3:0] request,  
    output reg [3:0] grant  
);  
    reg [1:0] current;  
    reg [1:0] next;  
      
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            current <= 2'b00;  
        end else begin  
            current <= next;  
        end  
    end  
      
    always @(*) begin  
        grant = 4'b0000;  
        case (current)  
            2'b00: if (request[0]) grant[0] = 1; else if (request[1]) grant[1] = 1;  
            2'b01: if (request[1]) grant[1] = 1; else if (request[2]) grant[2] = 1; else if (request[0]) grant[0] = 1;  
            2'b10: if (request[2]) grant[2] = 1; else if (request[3]) grant[3] = 1; else if (request[1]) grant[1] = 1;  
            2'b11: if (request[3]) grant[3] = 1; else if (request[0]) grant[0] = 1; else if (request[2]) grant[2] = 1;  
        endcase  
        next = (grant != 4'b0000) ? current : (current + 1) & 2'b11;  
    end  
endmodule