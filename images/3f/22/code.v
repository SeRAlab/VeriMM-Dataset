module ethernet_mac_controller(
    input clk,
    input reset,
    input send_start,
    input receive_start,
    output reg busy,
    output reg [1:0] state // 0: IDLE, 1: SENDING, 2: RECEIVING
);

    parameter IDLE = 2'b00;
    parameter SENDING = 2'b01;
    parameter RECEIVING = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            busy <= 0;
        end else begin
            case (state)
                IDLE: begin
                    busy <= 0;
                    if (send_start) begin
                        state <= SENDING;
                        busy <= 1;
                    end else if (receive_start) begin
                        state <= RECEIVING;
                        busy <= 1;
                    end
                end
                SENDING: begin
                    // Assume send operation is done here
                    state <= IDLE; // Transition back to IDLE after sending
                end
                RECEIVING: begin
                    // Assume receive operation is done here
                    state <= IDLE; // Transition back to IDLE after receiving
                end
            endcase
        end
    end
endmodule