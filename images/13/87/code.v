module CRC_4bit (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire [3:0] data_in,
    output reg [3:0] crc_out,
    output reg ready
);
    reg [3:0] crc;
    reg [1:0] state;
    reg [3:0] data;
    parameter IDLE = 2'b00, PROCESS = 2'b01, DONE = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            crc <= 4'b0000;
            ready <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (enable) begin
                        data <= data_in;
                        crc <= 4'b0000;
                        state <= PROCESS;
                        ready <= 0;
                    end
                end
                PROCESS: begin
                    // CRC processing using polynomial x^4 + x + 1 (10101)
                    crc[3] <= data[3] ^ crc[0];
                    crc[2] <= data[2] ^ crc[3] ^ crc[0];
                    crc[1] <= data[1] ^ crc[2] ^ crc[0];
                    crc[0] <= data[0] ^ crc[1];
                    state <= DONE;
                end
                DONE: begin
                    crc_out <= crc;
                    ready <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule