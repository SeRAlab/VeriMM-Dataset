module sata_controller (
    input clk,
    input reset,
    input control_signal, // 0 for READ, 1 for WRITE
    output reg [1:0] status // 00: IDLE, 01: READ, 10: WRITE
);

    parameter IDLE = 2'b00, READ = 2'b01, WRITE = 2'b10;
    reg [1:0] state, next_state;

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (control_signal) begin
                    next_state = WRITE;
                end else begin
                    next_state = READ;
                end
            end
            READ: begin
                next_state = IDLE; // Return to IDLE after READ
            end
            WRITE: begin
                next_state = IDLE; // Return to IDLE after WRITE
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            status <= IDLE;
        end else begin
            case (state)
                IDLE: status <= IDLE;
                READ: status <= READ;
                WRITE: status <= WRITE;
                default: status <= IDLE;
            endcase
        end
    end
endmodule