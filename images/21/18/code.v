module sd_card_interface (
    input clk,
    input rst_n,
    input [1:0] command,  // 00: IDLE, 01: READ, 10: WRITE
    output reg [1:0] state // 00: IDLE, 01: READ, 10: WRITE
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 2'b00; // IDLE state on reset
        end else begin
            case (state)
                2'b00: // IDLE
                    if (command == 2'b01)
                        state <= 2'b01; // Transition to READ
                    else if (command == 2'b10)
                        state <= 2'b10; // Transition to WRITE
                2'b01: // READ
                    state <= 2'b00; // Back to IDLE after READ
                2'b10: // WRITE
                    state <= 2'b00; // Back to IDLE after WRITE
                default: state <= 2'b00; // Default to IDLE
            endcase
        end
    end
endmodule