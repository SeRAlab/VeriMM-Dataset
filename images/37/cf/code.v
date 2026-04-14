module uart_transmitter (
    input wire clk,
    input wire reset,
    input wire transmit_en,
    input wire [7:0] data_in,
    output reg tx,
    output reg busy
);

    reg [3:0] state;
    reg [3:0] bit_count;
    reg [7:0] shift_reg;

    localparam IDLE = 4'd0;
    localparam START = 4'd1;
    localparam DATA = 4'd2;
    localparam STOP = 4'd3;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            tx <= 1'b1; // Idle state is high
            busy <= 1'b0;
            bit_count <= 4'd0;
        end else begin
            case (state)
                IDLE: begin
                    if (transmit_en) begin
                        shift_reg <= data_in;
                        bit_count <= 4'd0;
                        state <= START;
                        busy <= 1'b1;
                    end
                end
                
                START: begin
                    tx <= 1'b0; // Start bit
                    state <= DATA;
                end
                
                DATA: begin
                    if (bit_count < 4'd8) begin
                        tx <= shift_reg[bit_count]; // Transmit data bits
                        bit_count <= bit_count + 1;
                    end else begin
                        state <= STOP;
                    end
                end
                
                STOP: begin
                    tx <= 1'b1; // Stop bit
                    busy <= 1'b0;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule