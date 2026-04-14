module NVMeController (
    input clk,
    input rst,
    input start,
    output reg [1:0] state
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter PROCESSING = 2'b01;
    parameter COMPLETED = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;  // Reset to IDLE state
        else begin
            case (state)
                IDLE: begin
                    if (start)
                        state <= PROCESSING;  // Start processing
                end
                PROCESSING: begin
                    // Here we simulate processing by immediately transitioning to completed
                    state <= COMPLETED; // Move to completed state after processing
                end
                COMPLETED: begin
                    // You can return to idle or stay in completed state based on design
                    state <= IDLE;  // Go back to idle
                end
            endcase
        end
    end
endmodule