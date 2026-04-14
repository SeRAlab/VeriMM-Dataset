module i2c_controller (
    input clk,
    input reset,
    input start_condition,
    input stop_condition,
    input write_data,
    output reg sda,
    output reg scl,
    output reg ack,
    output reg [7:0] data_out
);

    reg [2:0] state;
    reg [2:0] next_state;
    reg [7:0] data;
    parameter IDLE = 3'b000, START = 3'b001, WRITE = 3'b010, READ = 3'b011, STOP = 3'b100;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            sda <= 1;
            scl <= 1;
            ack <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (start_condition) begin
                    next_state = START;
                end else begin
                    next_state = IDLE;
                end
            end
            START: begin
                sda = 0; // Start condition
                scl = 1;
                next_state = WRITE;
            end
            WRITE: begin
                sda = write_data; // Send data
                scl = 0;
                next_state = READ; // Move to read after write
            end
            READ: begin
                sda = 1; // Prepare to read
                ack = 1; // Acknowledge
                data_out = data; // Output data
                scl = 1;
                next_state = STOP;
            end
            STOP: begin
                sda = 0; // Stop condition
                scl = 1;
                sda = 1;
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule