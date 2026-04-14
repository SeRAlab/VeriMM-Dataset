module i2c_master (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] data_in,
    output reg scl,
    inout wire sda,
    output reg ack,
    output reg done
);
    
    reg [3:0] state;
    reg [7:0] data;
    reg [2:0] bit_cnt;
    
    localparam IDLE = 4'b0000,
               START = 4'b0001,
               TRANSMIT = 4'b0010,
               ACK_CHECK = 4'b0011,
               STOP = 4'b0100;
               
    assign sda = (state == TRANSMIT) ? data[7-bit_cnt] : 1'bz; // SDA is driven when transmitting
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            scl <= 1'b1;
            ack <= 1'b0;
            done <= 1'b0;
            bit_cnt <= 3'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        data <= data_in;
                        state <= START;
                    end
                end
                
                START: begin
                    scl <= 1'b0; // Start condition
                    state <= TRANSMIT;
                    bit_cnt <= 3'b0;
                end
                
                TRANSMIT: begin
                    if (bit_cnt < 8) begin
                        scl <= ~scl; // Toggle SCL
                        bit_cnt <= bit_cnt + 1;
                        if (bit_cnt == 7) begin
                            state <= ACK_CHECK;
                        end
                    end
                end
                
                ACK_CHECK: begin
                    scl <= 1'b1; // Prepare for ACK
                    ack <= sda;   // Read ACK from slave
                    state <= STOP;
                end
                
                STOP: begin
                    scl <= 1'b0; // Stop condition
                    state <= IDLE;
                    done <= 1'b1; // Transaction completed
                end
            endcase
        end
    end
endmodule