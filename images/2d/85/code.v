module i2c_controller (
    input wire clk,
    input wire enable,
    input wire rw, // 0 for write, 1 for read
    input wire [7:0] data_in,
    output reg SDA,
    output reg SCL,
    output reg ACK
);
    reg [3:0] state;
    reg [7:0] data_buffer;
    reg [3:0] bit_count;

    localparam IDLE = 4'b0000,
               START = 4'b0001,
               DATA = 4'b0010,
               ACK_SENT = 4'b0011,
               STOP = 4'b0100;

    always @(posedge clk) begin
        if (enable) begin
            case (state)
                IDLE: begin
                    SDA <= 1; // Idle state SDA high
                    SCL <= 1; // Idle state SCL high
                    bit_count <= 0;
                    state <= START;
                end

                START: begin
                    SDA <= 0; // Start condition
                    state <= DATA;
                    data_buffer <= data_in; // Load data
                end

                DATA: begin
                    SDA <= data_buffer[7 - bit_count]; // Send one bit
                    SCL <= 0; // Clock low
                    state <= (bit_count < 7) ? DATA : ACK_SENT;
                    if (bit_count < 7) bit_count <= bit_count + 1;
                    else bit_count <= 0;
                end

                ACK_SENT: begin
                    SCL <= 1; // Clock high
                    ACK <= SDA; // Read ACK
                    state <= STOP;
                end

                STOP: begin
                    SDA <= 0; // Pull SDA low
                    SCL <= 1; // Clock high to end transmission
                    SDA <= 1; // Stop condition
                    state <= IDLE; // Go back to idle
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule