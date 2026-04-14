module uart_transmitter (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] data,
    output reg tx,
    output reg ready
);

    reg [3:0] state;
    reg [3:0] bit_count;
    reg [9:0] shift_reg; // 1 start bit + 8 data bits + 1 stop bit

    parameter IDLE = 4'b0000;
    parameter START = 4'b0001;
    parameter DATA = 4'b0010;
    parameter STOP = 4'b0011;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            tx <= 1;
            ready <= 1;
            bit_count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        shift_reg <= {1'b1, data, 1'b0}; // load start and stop bits
                        state <= START;
                        ready <= 0;
                        bit_count <= 0;
                    end
                end
                START: begin
                    tx <= shift_reg[0]; // send start bit
                    state <= DATA;
                end
                DATA: begin
                    if (bit_count < 8) begin
                        tx <= shift_reg[bit_count + 1]; // send data bits
                        bit_count <= bit_count + 1;
                    end else begin
                        state <= STOP;
                    end
                end
                STOP: begin
                    tx <= 1; // send stop bit
                    ready <= 1; // signal that transmission is complete
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule