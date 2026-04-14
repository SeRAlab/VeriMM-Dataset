module i2c_master (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [6:0] slave_addr,
    input wire [7:0] data_in,
    output reg sda,
    output reg scl,
    output reg [7:0] data_out,
    output reg done
);
    reg [3:0] state;
    reg [3:0] bit_cnt;
    reg [7:0] shift_reg;
    localparam IDLE = 4'b0000, START = 4'b0001, ADDR = 4'b0010, WRITE = 4'b0011, READ = 4'b0100, STOP = 4'b0101;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            sda <= 1;
            scl <= 1;
            done <= 0;
            data_out <= 8'b0;
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
                    state <= ADDR;
                    bit_cnt <= 0;
                    shift_reg <= {slave_addr, 1'b0}; // Write operation
                end
                ADDR: begin
                    scl <= 0;
                    sda <= shift_reg[7 - bit_cnt]; // Send address bit
                    if (bit_cnt == 7) begin
                        state <= WRITE;
                    end else begin
                        bit_cnt <= bit_cnt + 1;
                    end
                end
                WRITE: begin
                    scl <= 0;
                    sda <= data_in[7 - bit_cnt]; // Send data bit
                    if (bit_cnt == 7) begin
                        state <= STOP;
                        done <= 1;
                    end else begin
                        bit_cnt <= bit_cnt + 1;
                    end
                end
                STOP: begin
                    sda <= 1; // Stop condition
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule