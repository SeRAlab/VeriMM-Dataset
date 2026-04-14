module pcie_endpoint_controller (  
    input wire clk,  
    input wire reset,  
    input wire connect,  
    input wire disconnect,  
    output reg [1:0] state, // 00 = IDLE, 01 = CONNECTED, 10 = DISCONNECTED  
    output reg active  
);  
    // State encoding  
    parameter IDLE = 2'b00;  
    parameter CONNECTED = 2'b01;  
    parameter DISCONNECTED = 2'b10;  
  
    // State transition logic  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            active <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (connect) begin  
                        state <= CONNECTED;  
                        active <= 1;  
                    end  
                end  
                CONNECTED: begin  
                    if (disconnect) begin  
                        state <= DISCONNECTED;  
                        active <= 0;  
                    end  
                end  
                DISCONNECTED: begin  
                    if (connect) begin  
                        state <= CONNECTED;  
                        active <= 1;  
                    end else begin  
                        state <= IDLE;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule