module uart_transmitter (
    input clk,
    input reset,
    input transmit, // Enable transmission
    input [7:0] data_in, // 8-bit data to transmit
    output reg tx, // Serial output
    output reg busy // Indicates if the transmitter is busy
);
    reg [3:0] state;
    reg [3:0] bit_index;
    reg [9:0] shift_reg; // 8 data bits + 1 start + 1 stop
    
    localparam IDLE = 4'd0,
               START = 4'd1,
               DATA = 4'd2,
               STOP = 4'd3;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            busy <= 0;
            tx <= 1; // Idle state is high
            bit_index <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (transmit) begin
                        shift_reg <= {1'b1, data_in, 1'b0}; // Stop bit, data, start bit
                        state <= START;
                        busy <= 1;
                        bit_index <= 0;
                    end
                end
                
                START: begin
                    tx <= 0; // Send start bit
                    state <= DATA;
                end
                
                DATA: begin
                    tx <= shift_reg[bit_index + 1]; // Send the next bit
                    if (bit_index < 8) begin
                        bit_index <= bit_index + 1;
                    end else begin
                        state <= STOP;
                    end
                end
                
                STOP: begin
                    tx <= 1; // Send stop bit
                    busy <= 0;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule