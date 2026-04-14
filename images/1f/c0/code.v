module round_robin_arbiter (  
    input clk,  
    input rst,  
    input [3:0] req,  
    output reg [3:0] grant  
);  
    reg [1:0] state; // State variable to track the current grant  
    reg [1:0] next_state;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= 2'b00;  
        end else begin  
            state <= next_state;  
        end  
    end  

    always @* begin  
        grant = 4'b0000;  
        case (state)  
            2'b00: begin  
                if (req[0]) begin  
                    grant[0] = 1;  
                    next_state = 2'b01;  
                end else if (req[1]) begin  
                    grant[1] = 1;  
                    next_state = 2'b10;  
                end else if (req[2]) begin  
                    grant[2] = 1;  
                    next_state = 2'b11;  
                end else if (req[3]) begin  
                    grant[3] = 1;  
                    next_state = 2'b00;  
                end else begin  
                    next_state = 2'b00;  
                end  
            end  
            2'b01: begin  
                if (req[1]) begin  
                    grant[1] = 1;  
                    next_state = 2'b10;  
                end else if (req[2]) begin  
                    grant[2] = 1;  
                    next_state = 2'b11;  
                end else if (req[3]) begin  
                    grant[3] = 1;  
                    next_state = 2'b00;  
                end else if (req[0]) begin  
                    grant[0] = 1;  
                    next_state = 2'b01;  
                end else begin  
                    next_state = 2'b00;  
                end  
            end  
            2'b10: begin  
                if (req[2]) begin  
                    grant[2] = 1;  
                    next_state = 2'b11;  
                end else if (req[3]) begin  
                    grant[3] = 1;  
                    next_state = 2'b00;  
                end else if (req[0]) begin  
                    grant[0] = 1;  
                    next_state = 2'b01;  
                end else if (req[1]) begin  
                    grant[1] = 1;  
                    next_state = 2'b10;  
                end else begin  
                    next_state = 2'b00;  
                end  
            end  
            2'b11: begin  
                if (req[3]) begin  
                    grant[3] = 1;  
                    next_state = 2'b00;  
                end else if (req[0]) begin  
                    grant[0] = 1;  
                    next_state = 2'b01;  
                end else if (req[1]) begin  
                    grant[1] = 1;  
                    next_state = 2'b10;  
                end else if (req[2]) begin  
                    grant[2] = 1;  
                    next_state = 2'b11;  
                end else begin  
                    next_state = 2'b00;  
                end  
            end  
            default: next_state = 2'b00;  
        endcase  
    end  
endmodule