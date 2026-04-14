module sd_card_controller (
    input clk,
    input reset,
    input start,
    output reg [1:0] state
);

    // State encoding
    parameter IDLE = 2'b00, INIT = 2'b01, READ = 2'b10, WRITE = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start)
                        state <= INIT;
                    else
                        state <= IDLE;
                end
                INIT: begin
                    state <= READ; // Assume INIT leads to READ directly
                end
                READ: begin
                    state <= WRITE; // Read leads to Write
                end
                WRITE: begin
                    state <= IDLE; // Write leads back to IDLE
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule