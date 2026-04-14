module sliding_window_fsm(
    input clk,
    input reset,
    input send_packet,
    input ack_received,
    output reg [1:0] state,  // 0: IDLE, 1: SEND, 2: WAIT
    output reg window_full,
    output reg [1:0] current_packet  // 0 to 2 for up to 3 packets
);
    
    // State encoding
    parameter IDLE = 2'b00, SEND = 2'b01, WAIT = 2'b10;
    
    // Packet counter 
    reg [1:0] packet_counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            packet_counter <= 0;
            current_packet <= 0;
            window_full <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (send_packet && !window_full) begin
                        state <= SEND;
                    end
                end
                
                SEND: begin
                    current_packet <= packet_counter;
                    if (packet_counter < 2) begin
                        packet_counter <= packet_counter + 1;
                    end else begin
                        window_full <= 1;
                    end
                    state <= WAIT;
                end
                
                WAIT: begin
                    if (ack_received) begin
                        if (packet_counter > 0) begin
                            packet_counter <= packet_counter - 1;
                            current_packet <= packet_counter - 1;
                            window_full <= 0;
                        end
                        state <= IDLE;
                    end
                end
                
                default: state <= IDLE;
            endcase
        end
    end
endmodule