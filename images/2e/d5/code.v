module sd_card_controller(
    input clk,
    input reset,
    input start_read,
    input start_write,
    input error_signal,
    output reg [1:0] current_state,
    output reg read_complete,
    output reg write_complete
);
    // State encoding
    parameter IDLE = 2'b00, READ = 2'b01, WRITE = 2'b10, ERROR = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            read_complete <= 0;
            write_complete <= 0;
        end else begin
            case (current_state)
                IDLE: begin
                    read_complete <= 0;
                    write_complete <= 0;
                    if (start_read) begin
                        current_state <= READ;
                    end else if (start_write) begin
                        current_state <= WRITE;
                    end
                end
                
                READ: begin
                    // Simulate read operation
                    current_state <= IDLE; // Transition back to IDLE after read
                    read_complete <= 1;
                end
                
                WRITE: begin
                    // Simulate write operation
                    current_state <= IDLE; // Transition back to IDLE after write
                    write_complete <= 1;
                end
                
                ERROR: begin
                    // Handle error state
                    if (!error_signal) begin
                        current_state <= IDLE; // Clear error state
                    end
                end
                
                default: current_state <= IDLE;
            endcase
        end
    end
endmodule