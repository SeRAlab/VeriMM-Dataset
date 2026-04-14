module sata_controller (
    input clk,
    input reset,
    input start_read,
    input start_write,
    output reg [1:0] state // 00: IDLE, 01: READ, 10: WRITE, 11: ERROR
);
    parameter IDLE = 2'b00, READ = 2'b01, WRITE = 2'b10, ERROR = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start_read) state <= READ;
                    else if (start_write) state <= WRITE;
                end
                READ: begin
                    // Simulate reading operation
                    state <= IDLE; // Transition back to IDLE after read
                end
                WRITE: begin
                    // Simulate writing operation
                    state <= IDLE; // Transition back to IDLE after write
                end
                default: state <= ERROR; // Catch-all for errors
            endcase
        end
    end
endmodule