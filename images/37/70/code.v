module nvme_controller(
    input clk,
    input reset,
    input read_cmd,
    input write_cmd,
    output reg [1:0] current_state
);
    // State encoding
    localparam IDLE = 2'b00,
               READ = 2'b01,
               WRITE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            case (current_state)
                IDLE: begin
                    if (read_cmd) begin
                        current_state <= READ;
                    end else if (write_cmd) begin
                        current_state <= WRITE;
                    end
                end
                READ: begin
                    // Simulate read operation completion
                    current_state <= IDLE; // Transition back to IDLE after read
                end
                WRITE: begin
                    // Simulate write operation completion
                    current_state <= IDLE; // Transition back to IDLE after write
                end
            endcase
        end
    end
endmodule