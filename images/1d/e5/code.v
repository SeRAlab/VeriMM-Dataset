module nvme_controller (
    input wire clk,
    input wire start,
    input wire done_signal,
    output reg [1:0] state // 00: IDLE, 01: BUSY, 10: DONE
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter BUSY = 2'b01;
    parameter DONE = 2'b10;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (start) begin
                    state <= BUSY;
                end
            end
            BUSY: begin
                // Simulate processing
                state <= DONE;
            end
            DONE: begin
                if (done_signal) begin
                    state <= IDLE;
                end
            end
        endcase
    end

    initial begin
        state = IDLE; // Initial state
    end
endmodule