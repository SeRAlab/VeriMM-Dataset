module round_robin_arbiter(  
    input clk,  
    input reset,  
    input request0,  
    input request1,  
    input request2,  
    input request3,  
    output reg grant0,  
    output reg grant1,  
    output reg grant2,  
    output reg grant3  
);  
    reg [1:0] current_priority;  
    reg [1:0] next_priority;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_priority <= 2'b00;  
        end else begin  
            current_priority <= next_priority;  
        end  
    end  

    always @(*) begin  
        grant0 = 0;  
        grant1 = 0;  
        grant2 = 0;  
        grant3 = 0;  
        
        case (current_priority)  
            2'b00: begin  
                if (request0) begin  
                    grant0 = 1;  
                    next_priority = 2'b01;  
                end else if (request1) begin  
                    grant1 = 1;  
                    next_priority = 2'b10;  
                end else if (request2) begin  
                    grant2 = 1;  
                    next_priority = 2'b11;  
                end else if (request3) begin  
                    grant3 = 1;  
                    next_priority = 2'b00;  
                end else begin  
                    next_priority = 2'b00;  
                end  
            end  
            2'b01: begin  
                if (request1) begin  
                    grant1 = 1;  
                    next_priority = 2'b10;  
                end else if (request2) begin  
                    grant2 = 1;  
                    next_priority = 2'b11;  
                end else if (request3) begin  
                    grant3 = 1;  
                    next_priority = 2'b00;  
                end else if (request0) begin  
                    grant0 = 1;  
                    next_priority = 2'b01;  
                end else begin  
                    next_priority = 2'b01;  
                end  
            end  
            2'b10: begin  
                if (request2) begin  
                    grant2 = 1;  
                    next_priority = 2'b11;  
                end else if (request3) begin  
                    grant3 = 1;  
                    next_priority = 2'b00;  
                end else if (request0) begin  
                    grant0 = 1;  
                    next_priority = 2'b01;  
                end else if (request1) begin  
                    grant1 = 1;  
                    next_priority = 2'b10;  
                end else begin  
                    next_priority = 2'b10;  
                end  
            end  
            2'b11: begin  
                if (request3) begin  
                    grant3 = 1;  
                    next_priority = 2'b00;  
                end else if (request0) begin  
                    grant0 = 1;  
                    next_priority = 2'b01;  
                end else if (request1) begin  
                    grant1 = 1;  
                    next_priority = 2'b10;  
                end else if (request2) begin  
                    grant2 = 1;  
                    next_priority = 2'b11;  
                end else begin  
                    next_priority = 2'b11;  
                end  
            end  
        endcase  
    end  
endmodule