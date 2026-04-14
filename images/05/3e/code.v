module uart_controller(
    input clk,
    input reset,
    input send,
    input receive,
    input [7:0] data_in,
    output reg tx,
    output reg [7:0] data_out,
    output reg data_sent,
    output reg data_received
);
    reg [3:0] state;
    reg [7:0] tx_data;
    reg [3:0] bit_count;

    parameter IDLE = 4'b0000;
    parameter SEND_START = 4'b0001;
    parameter SEND_DATA = 4'b0010;
    parameter SEND_STOP = 4'b0011;
    parameter RECEIVE_START = 4'b0100;
    parameter RECEIVE_DATA = 4'b0101;
    parameter RECEIVE_STOP = 4'b0110;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            tx <= 1;
            data_sent <= 0;
            data_received <= 0;
            bit_count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (send) begin
                        tx_data <= data_in;
                        state <= SEND_START;
                        data_sent <= 0;
                    end else if (receive) begin
                        state <= RECEIVE_START;
                        data_received <= 0;
                    end
                end
                
                SEND_START: begin
                    tx <= 0; // Start bit
                    state <= SEND_DATA;
                    bit_count <= 0;
                end
                
                SEND_DATA: begin
                    tx <= tx_data[bit_count]; // Send data bit
                    if (bit_count < 7) begin
                        bit_count <= bit_count + 1;
                    end else begin
                        state <= SEND_STOP;
                    end
                end
                
                SEND_STOP: begin
                    tx <= 1; // Stop bit
                    state <= IDLE;
                    data_sent <= 1;
                end
                
                RECEIVE_START: begin
                    // Logic to detect start bit and read data would go here
                    // Placeholder for simplicity
                    state <= RECEIVE_DATA;
                end
                
                RECEIVE_DATA: begin
                    // Placeholder for simplicity
                    // Logic to read data bits would go here
                    state <= RECEIVE_STOP;
                end
                
                RECEIVE_STOP: begin
                    // Placeholder for simplicity
                    state <= IDLE;
                    data_received <= 1;
                end
                
                default: state <= IDLE;
            endcase
        end
    end
endmodule