module nvme_controller (
    input wire clk,
    input wire reset,
    input wire start_command,
    input wire read_command,
    input wire write_command,
    output reg [1:0] current_state // 00: IDLE, 01: READ, 10: WRITE, 11: DONE
);

    // State encoding
    localparam IDLE   = 2'b00;
    localparam READ   = 2'b01;
    localparam WRITE  = 2'b10;
    localparam DONE   = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            case (current_state)
                IDLE: begin
                    if (start_command) begin
                        if (read_command) begin
                            current_state <= READ;
                        end else if (write_command) begin
                            current_state <= WRITE;
                        end
                    end
                end
                READ: begin
                    current_state <= DONE; // Transition to DONE after READ operation
                end
                WRITE: begin
                    current_state <= DONE; // Transition to DONE after WRITE operation
                end
                DONE: begin
                    current_state <= IDLE; // Reset to IDLE
                end
                default: current_state <= IDLE;
            endcase
        end
    end
endmodule