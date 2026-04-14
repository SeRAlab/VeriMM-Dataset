module ethernet_mac_controller (
    input wire clk,
    input wire rst,
    input wire start_tx,
    input wire [7:0] frame_data,
    output reg tx_in_progress,
    output reg tx_complete
);

    reg [1:0] state; // 0: idle, 1: transmitting, 2: done
    parameter IDLE = 2'b00, TRANSMITTING = 2'b01, DONE = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            tx_in_progress <= 0;
            tx_complete <= 0;
        end else begin
            case (state)
                IDLE: begin
                    tx_in_progress <= 0;
                    tx_complete <= 0;
                    if (start_tx) begin
                        state <= TRANSMITTING;
                    end
                end
                TRANSMITTING: begin
                    tx_in_progress <= 1;
                    // Simulate transmission delay
                    state <= DONE;
                end
                DONE: begin
                    tx_in_progress <= 0;
                    tx_complete <= 1;
                    state <= IDLE; // go back to idle after transmission
                end
            endcase
        end
    end
endmodule