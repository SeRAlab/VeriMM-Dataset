module sd_card_controller (
    input wire clk,
    input wire start_read,
    input wire start_write,
    output reg [1:0] state // 00: IDLE, 01: READ, 10: WRITE
);

    localparam IDLE = 2'b00;
    localparam READ = 2'b01;
    localparam WRITE = 2'b10;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (start_read) begin
                    state <= READ;
                end else if (start_write) begin
                    state <= WRITE;
                end
            end
            READ: begin
                // Transition back to IDLE after reading
                state <= IDLE;
            end
            WRITE: begin
                // Transition back to IDLE after writing
                state <= IDLE;
            end
            default: state <= IDLE; // Reset to IDLE
        endcase
    end

    initial begin
        state = IDLE; // Initialize state
    end
endmodule