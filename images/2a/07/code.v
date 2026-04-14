module ethernet_mac_controller (
    input wire clk,
    input wire reset,
    input wire new_frame,
    output reg [1:0] state, // 00: IDLE, 01: RECEIVE, 10: PROCESS, 11: TRANSMIT
    output reg frame_processing,
    output reg frame_transmitted
);
    // State encoding
    parameter IDLE = 2'b00;
    parameter RECEIVE = 2'b01;
    parameter PROCESS = 2'b10;
    parameter TRANSMIT = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            frame_processing <= 0;
            frame_transmitted <= 0;
        end else begin
            case (state)
                IDLE: begin
                    frame_processing <= 0;
                    frame_transmitted <= 0;
                    if (new_frame) begin
                        state <= RECEIVE;
                    end
                end
                RECEIVE: begin
                    frame_processing <= 1;
                    state <= PROCESS;
                end
                PROCESS: begin
                    // Simulate some processing here
                    state <= TRANSMIT;
                end
                TRANSMIT: begin
                    frame_transmitted <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule