module i2c_master(
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] data_in,
    output reg scl,
    output reg sda,
    output reg done
);
    reg [3:0] state;
    reg [3:0] count;
    
    localparam IDLE = 4'b0000,
               START = 4'b0001,
               SEND_ADDR = 4'b0010,
               SEND_DATA = 4'b0011,
               STOP = 4'b0100;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            scl <= 1;
            sda <= 1;
            done <= 0;
            count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= START;
                        done <= 0;
                    end
                end
                START: begin
                    sda <= 0; // Start condition
                    state <= SEND_ADDR;
                end
                SEND_ADDR: begin
                    if (count < 8) begin
                        scl <= 0;
                        sda <= data_in[count]; // Sending data bit
                        count <= count + 1;
                        state <= SEND_DATA;
                    end else begin
                        // Assume Acknowledgment received
                        count <= 0;
                        state <= SEND_DATA;
                    end
                end
                SEND_DATA: begin
                    if (count < 8) begin
                        scl <= 0;
                        sda <= data_in[count]; // Sending data byte
                        count <= count + 1;
                    end else begin
                        state <= STOP;
                    end
                end
                STOP: begin
                    scl <= 0;
                    sda <= 1; // Stop condition
                    state <= IDLE;
                    done <= 1;
                end
            endcase
        end
    end
endmodule