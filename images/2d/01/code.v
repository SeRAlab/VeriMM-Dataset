module TemperatureSensorController(
    input wire clk,
    input wire reset,
    input wire read,
    input wire [2:0] temperature,
    output reg alarm,
    output reg [1:0] state // 00: IDLE, 01: READ, 10: PROCESS
);
    // State encoding
    localparam IDLE = 2'b00;
    localparam READ = 2'b01;
    localparam PROCESS = 2'b10;

    // State register
    reg [1:0] current_state, next_state;

    // Sequential logic for state transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational logic for next state and output logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                alarm = 0;
                if (read) begin
                    next_state = READ;
                end else begin
                    next_state = IDLE;
                end
            end
            READ: begin
                next_state = PROCESS;
            end
            PROCESS: begin
                if (temperature > 3) begin
                    alarm = 1;
                end else begin
                    alarm = 0;
                end
                next_state = IDLE;
            end
            default: begin
                next_state = IDLE;
                alarm = 0;
            end
        endcase
        state = current_state;
    end
endmodule