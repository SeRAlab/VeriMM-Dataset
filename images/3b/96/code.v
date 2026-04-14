module pcie_endpoint_controller (
    input clk,
    input reset,
    input req_read,
    input req_write,
    output reg busy,
    output reg [1:0] state // 00: IDLE, 01: READ, 10: WRITE, 11: ERROR
);

    // State encoding
    parameter IDLE = 2'b00, READ = 2'b01, WRITE = 2'b10, ERROR = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            busy <= 0;
        end else begin
            case (state)
                IDLE: begin
                    busy <= 0;
                    if (req_read) begin
                        state <= READ;
                        busy <= 1;
                    end else if (req_write) begin
                        state <= WRITE;
                        busy <= 1;
                    end
                end
                READ: begin
                    // Simulate read operation
                    state <= IDLE; // Move back to IDLE after read
                end
                WRITE: begin
                    // Simulate write operation
                    state <= IDLE; // Move back to IDLE after write
                end
                ERROR: begin
                    // Handle error state
                    state <= IDLE; // Reset to IDLE after an error
                end
            endcase
        end
    end
endmodule