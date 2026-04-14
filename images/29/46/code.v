module nvme_controller(
    input clk,
    input reset,
    input start_read,
    input start_write,
    output reg [1:0] state
);
    // State encoding
    parameter IDLE = 2'b00, READ = 2'b01, WRITE = 2'b10, DONE = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start_read)
                        state <= READ;
                    else if (start_write)
                        state <= WRITE;
                end
                READ: begin
                    state <= DONE;
                end
                WRITE: begin
                    state <= DONE;
                end
                DONE: begin
                    state <= IDLE; // Automatically return to IDLE after DONE
                end
                default: state <= IDLE; // Default state
            endcase
        end
    end
endmodule