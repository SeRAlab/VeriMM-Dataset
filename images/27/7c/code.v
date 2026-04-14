module i2c_controller (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] data_in,
    output reg sda,
    output reg scl,
    output reg done
);
    reg [3:0] state;
    reg [7:0] data;
    reg [2:0] bit_count;

    localparam IDLE = 4'd0,
               START = 4'd1,
               SEND = 4'd2,
               STOP = 4'd3;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            sda <= 1;
            scl <= 1;
            done <= 0;
            bit_count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= START;
                        data <= data_in;
                        done <= 0;
                    end
                end
                START: begin
                    sda <= 0; // Start condition
                    state <= SEND;
                end
                SEND: begin
                    if (bit_count < 8) begin
                        sda <= data[7-bit_count]; // Send the data bit
                        scl <= 0; // Clock low
                        #1 scl <= 1; // Clock high
                        bit_count <= bit_count + 1;
                    end else begin
                        state <= STOP;
                    end
                end
                STOP: begin
                    sda <= 0; // Hold low during stop condition
                    scl <= 1; // Clock high
                    #1 sda <= 1; // Release SDA
                    done <= 1; // Transmission complete
                    state <= IDLE; // Go back to idle
                end
            endcase
        end
    end
endmodule