module nvme_controller (
    input wire clk,
    input wire rst,
    input wire read_cmd,
    input wire write_cmd,
    output reg [1:0] state // 00: IDLE, 01: READ, 10: WRITE
);

    // Define states
    parameter IDLE = 2'b00;
    parameter READ = 2'b01;
    parameter WRITE = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (read_cmd) state <= READ;
                    else if (write_cmd) state <= WRITE;
                end
                READ: begin
                    // Assume read operation is instantaneous for this example
                    state <= IDLE; // Transition back to IDLE after read
                end
                WRITE: begin
                    // Assume write operation is instantaneous for this example
                    state <= IDLE; // Transition back to IDLE after write
                end
                default: state <= IDLE; // Fallback
            endcase
        end
    end
endmodule