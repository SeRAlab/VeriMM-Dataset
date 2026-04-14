module sata_controller (
    input clk,
    input reset,
    input start,
    input complete,
    output reg [1:0] state // 00: IDLE, 01: READ, 10: WRITE, 11: DONE
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // IDLE
        end else begin
            case (state)
                2'b00: begin // IDLE
                    if (start) state <= 2'b01; // Transition to READ
                end
                2'b01: begin // READ
                    if (complete) state <= 2'b10; // Transition to WRITE
                end
                2'b10: begin // WRITE
                    if (complete) state <= 2'b11; // Transition to DONE
                end
                2'b11: begin // DONE
                    state <= 2'b00; // Go back to IDLE
                end
            endcase
        end
    end
endmodule