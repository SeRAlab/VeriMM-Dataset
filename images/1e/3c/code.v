module traffic_light_controller(  
    input wire clk,  
    input wire rst,  
    output reg [1:0] state // 00 = RED, 01 = GREEN, 10 = YELLOW  
);  
    reg [3:0] counter; // Count clock cycles  

    // State Encoding  
    parameter RED = 2'b00;  
    parameter GREEN = 2'b01;  
    parameter YELLOW = 2'b10;  

    // State Transition Logic  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= RED;  
            counter <= 0;  
        end else begin  
            counter <= counter + 1;  
            case (state)  
                RED: begin  
                    if (counter == 4'd4) begin  
                        state <= GREEN;  
                        counter <= 0;  
                    end  
                end  
                GREEN: begin  
                    if (counter == 4'd3) begin  
                        state <= YELLOW;  
                        counter <= 0;  
                    end  
                end  
                YELLOW: begin  
                    if (counter == 4'd0) begin  
                        state <= RED;  
                        counter <= 0;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule