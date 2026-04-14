module ethernet_mac_controller (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input send,
    output reg tx_done,
    output reg [7:0] status_reg
);
    reg [1:0] state; // 0: idle, 1: transmitting, 2: done

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 0;
            tx_done <= 0;
            status_reg <= 8'h00;
        end else begin
            case (state)
                0: begin
                    tx_done <= 0;
                    if (send) begin
                        status_reg <= data_in; // Load data into status register
                        state <= 1; // Move to transmitting state
                    end
                end
                1: begin
                    // Simulate transmission delay
                    tx_done <= 0;
                    state <= 2; // Move to done state after transmitting
                end
                2: begin
                    tx_done <= 1; // Transmission done
                    state <= 0; // Go back to idle
                end
            endcase
        end
    end
endmodule