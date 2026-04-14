module I2C_Master (
    input clk,
    input reset,
    input start,
    input [7:0] data_in,
    output reg scl,
    output reg sda,
    output reg done
);
    reg [3:0] state;
    parameter IDLE = 4'b0000, START = 4'b0001, SEND = 4'b0010, STOP = 4'b0011, ACK = 4'b0100;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            scl <= 1;
            sda <= 1;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) state <= START;
                end
                START: begin
                    sda <= 0; // START condition
                    state <= SEND;
                end
                SEND: begin
                    // Sending byte (simulate this, not actual bit-banging)
                    sda <= data_in[7];
                    // Shift data_in for next bit (not implemented in simple form)
                    state <= STOP; // For simplicity, go to STOP
                end
                STOP: begin
                    sda <= 0; // Prepare for STOP condition
                    scl <= 0; // Lower SCL
                    sda <= 1; // STOP condition
                    done <= 1;
                    state <= IDLE; // Go back to IDLE
                end
            endcase
        end
    end
endmodule