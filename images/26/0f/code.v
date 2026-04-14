module bluetooth_fsm(  
    input wire clk,  
    input wire rst,  
    input wire connect_req,  
    input wire disconnect_req,  
    output reg [1:0] state // 00: Idle, 01: Connecting, 10: Connected, 11: Disconnected  
);  

    // State encoding  
    localparam IDLE = 2'b00,  
               CONNECTING = 2'b01,  
               CONNECTED = 2'b10,  
               DISCONNECTED = 2'b11;  

    // State transition logic  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (connect_req)  
                        state <= CONNECTING;  
                end  
                CONNECTING: begin  
                    state <= CONNECTED;  
                end  
                CONNECTED: begin  
                    if (disconnect_req)  
                        state <= DISCONNECTED;  
                end  
                DISCONNECTED: begin  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule