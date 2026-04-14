module ethernet_mac_controller (
    input clk,
    input reset,
    input start_receive,
    input start_transmit,
    output reg [1:0] state,  // 00: IDLE, 01: RECEIVE, 10: TRANSMIT
    output reg ready
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam TRANSMIT = 2'b10;

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            ready <= 1'b1;
        end else begin
            case (state)
                IDLE: begin
                    if (start_receive) begin
                        state <= RECEIVE;
                        ready <= 1'b0;
                    end else if (start_transmit) begin
                        state <= TRANSMIT;
                        ready <= 1'b0;
                    end
                end
                RECEIVE: begin
                    // Simulate receiving data
                    ready <= 1'b1;  // Ready after reception
                    state <= IDLE;  // Go back to IDLE after receiving
                end
                TRANSMIT: begin
                    // Simulate transmitting data
                    ready <= 1'b1;  // Ready after transmission
                    state <= IDLE;  // Go back to IDLE after transmitting
                end
            endcase
        end
    end
endmodule