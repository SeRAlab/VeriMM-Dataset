module I2C_Master (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] data_in,
    output reg sda,
    output reg scl,
    output reg busy,
    output reg ack
);

    reg [3:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    parameter IDLE = 4'b0000;
    parameter START = 4'b0001;
    parameter SEND_DATA = 4'b0010;
    parameter STOP = 4'b0011;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            busy <= 0;
            ack <= 0;
        end else begin
            case (state)
                IDLE: begin
                    busy <= 0;
                    if (start) begin
                        data_reg <= data_in;
                        state <= START;
                        busy <= 1;
                    end
                end
                
                START: begin
                    sda <= 0; // Start condition
                    state <= SEND_DATA;
                    bit_count <= 7;
                end
                
                SEND_DATA: begin
                    scl <= 0; // Prepare for data transmission
                    sda <= data_reg[bit_count]; // Send the current bit
                    if (bit_count == 0) begin
                        state <= STOP;
                    end else begin
                        bit_count <= bit_count - 1;
                    end
                end
                
                STOP: begin
                    scl <= 1; // Final clock pulse
                    sda <= 1; // Stop condition
                    ack <= 1; // Acknowledge signal (dummy)
                    state <= IDLE; // Return to idle
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule