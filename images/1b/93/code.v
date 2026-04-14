module ethernet_mac_controller (
    input wire clk,
    input wire reset,
    input wire start_tx,
    input wire ack,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg [1:0] state // 00: IDLE, 01: TRANSMITTING, 10: WAIT_FOR_ACK
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam TRANSMITTING = 2'b01;
    localparam WAIT_FOR_ACK = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            data_out <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start_tx) begin
                        data_out <= data_in;
                        state <= TRANSMITTING;
                    end
                end
                TRANSMITTING: begin
                    state <= WAIT_FOR_ACK;
                end
                WAIT_FOR_ACK: begin
                    if (ack) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule