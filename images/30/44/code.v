module nvme_controller (
    input wire clk,
    input wire reset,
    input wire command,
    output reg [1:0] state // 00: IDLE, 01: PROCESSING, 10: COMPLETE
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter PROCESSING = 2'b01;
    parameter COMPLETE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE; // On reset, go to IDLE state
        end else begin
            case (state)
                IDLE: begin
                    if (command) begin
                        state <= PROCESSING; // Go to PROCESSING if command is received
                    end
                end
                PROCESSING: begin
                    state <= COMPLETE; // Go to COMPLETE after processing
                end
                COMPLETE: begin
                    state <= IDLE; // After complete, return to IDLE
                end
            endcase
        end
    end
endmodule