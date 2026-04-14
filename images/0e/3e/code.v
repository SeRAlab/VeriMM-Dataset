module deadbeat_controller (  
    input clk,  
    input rst,  
    input [2:0] x,  
    output reg [2:0] y  
);  
    reg [1:0] state;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= 2'b00;  
            y <= 3'b000;  
        end else begin  
            case (state)  
                2'b00: begin  
                    y <= x;  
                    state <= 2'b01;  
                end  
                2'b01: begin  
                    y <= x;  
                    state <= 2'b10;  
                end  
                2'b10: begin  
                    y <= x;  
                    state <= 2'b00;  
                end  
                default: begin  
                    state <= 2'b00;  
                end  
            endcase  
        end  
    end  
endmodule