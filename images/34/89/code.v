module wifi_control (
    input wire clk,
    input wire rst,
    input wire connect_req,
    output reg [1:0] state
);
    parameter DISCONNECTED = 2'b00;
    parameter CONNECTING = 2'b01;
    parameter CONNECTED = 2'b10;
    parameter CONNECT_TIME = 4; // Number of clock cycles to stay in CONNECTING

    reg [1:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= DISCONNECTED;
            count <= 2'b00;
        end else begin
            case (state)
                DISCONNECTED: begin
                    if (connect_req) begin
                        state <= CONNECTING;
                        count <= 2'b00;
                    end
                end
                CONNECTING: begin
                    if (count < CONNECT_TIME) begin
                        count <= count + 1;
                    end else begin
                        state <= CONNECTED;
                        count <= 2'b00;
                    end
                end
                CONNECTED: begin
                    // Remain in CONNECTED state until reset
                end
            endcase
        end
    end
endmodule