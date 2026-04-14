module wifi_module (  
    input clk,  
    input reset,  
    input [1:0] state_input,  
    output reg [1:0] current_state  
);  
    // State encoding  
    parameter IDLE = 2'b00;  
    parameter SCANNING = 2'b01;  
    parameter CONNECTING = 2'b10;  
    parameter CONNECTED = 2'b11;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_state <= IDLE;  
        end else begin  
            case (state_input)  
                2'b00: current_state <= IDLE;  
                2'b01: current_state <= SCANNING;  
                2'b10: current_state <= CONNECTING;  
                2'b11: current_state <= CONNECTED;  
                default: current_state <= IDLE;  
            endcase  
        end  
    end  
endmodule