module wifi_controller (
    input wire clk,
    input wire rst,
    input wire [1:0] command, // 00: NO_OP, 01: ENABLE, 10: DISABLE, 11: CONNECT
    input wire [31:0] ssid, // SSID of the network to connect
    output reg wifi_enabled,
    output reg connected,
    output reg [31:0] current_ssid // stores the current SSID
);
    // State encoding
    parameter IDLE = 2'b00, ENABLED = 2'b01, DISABLED = 2'b10, CONNECTED = 2'b11;
    
    reg [1:0] state, next_state;

    // State transition logic
    always @(posedge clk or posedge rst) begin
        if (rst) 
            state <= IDLE;
        else 
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                wifi_enabled = 0;
                connected = 0;
                if (command == 2'b01) next_state = ENABLED;
                else next_state = IDLE;
            end
            ENABLED: begin
                wifi_enabled = 1;
                connected = 0;
                if (command == 2'b10) next_state = DISABLED;
                else if (command == 2'b11) begin
                    next_state = CONNECTED;
                    current_ssid = ssid;
                end else
                    next_state = ENABLED;
            end
            DISABLED: begin
                wifi_enabled = 0;
                connected = 0;
                if (command == 2'b01) next_state = ENABLED;
                else next_state = DISABLED;
            end
            CONNECTED: begin
                wifi_enabled = 1;
                connected = 1;
                if (command == 2'b10) next_state = DISABLED;
                else next_state = CONNECTED;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule