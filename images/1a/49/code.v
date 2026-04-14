module wifi_fsm(  
    input wire clk,  
    input wire reset,  
    input wire start,  
    output reg [1:0] state  
);  
    // State encoding  
    parameter IDLE = 2'b00, CONNECTING = 2'b01, CONNECTED = 2'b10;  
    reg [2:0] counter; // 3-bit counter for timing  
      
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            counter <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        state <= CONNECTING;  
                        counter <= 0;  
                    end  
                end  
                CONNECTING: begin  
                    if (counter < 5) begin  
                        counter <= counter + 1;  
                    end else begin  
                        state <= CONNECTED;  
                    end  
                end  
                CONNECTED: begin  
                    // Remain in CONNECTED state until reset  
                end  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule