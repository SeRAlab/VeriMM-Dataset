module sd_card_interface (
    input clk,
    input reset,
    input read_req,
    input write_req,
    output reg [1:0] current_state // 00 - IDLE, 01 - READ, 10 - WRITE, 11 - ERROR
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam READ = 2'b01;
    localparam WRITE = 2'b10;
    localparam ERROR = 2'b11;

    // Sequential logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            case (current_state)
                IDLE: begin
                    if (read_req) begin
                        current_state <= READ;
                    end else if (write_req) begin
                        current_state <= WRITE;
                    end
                end
                READ: begin
                    // Simulating a read operation completion
                    current_state <= IDLE; // Transition back to IDLE after read
                end
                WRITE: begin
                    // Simulating a write operation completion
                    current_state <= IDLE; // Transition back to IDLE after write
                end
                ERROR: begin
                    current_state <= IDLE; // Reset to IDLE on error
                end
                default: current_state <= IDLE;
            endcase
        end
    end

endmodule