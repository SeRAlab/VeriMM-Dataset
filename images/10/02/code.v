module wifi_state_machine (  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire connect,  
    input wire disconnect,  
    output reg [1:0] state  
);  
    // State encoding  
    localparam IDLE = 2'b00;  
    localparam CONNECTING = 2'b01;  
    localparam CONNECTED = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start)  
                        state <= CONNECTING;  
                end  
                CONNECTING: begin  
                    if (connect)  
                        state <= CONNECTED;  
                    else if (disconnect)  
                        state <= IDLE;  
                end  
                CONNECTED: begin  
                    if (disconnect)  
                        state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule