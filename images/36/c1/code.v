module pcie_endpoint_controller (
    input clk,
    input reset,
    input request,
    input data_ready,
    output reg [1:0] state // 00 - IDLE, 01 - REQUEST_RECEIVED, 10 - DATA_TRANSFER, 11 - COMPLETED
);

    // State encoding
    parameter IDLE = 2'b00, 
              REQUEST_RECEIVED = 2'b01,
              DATA_TRANSFER = 2'b10,
              COMPLETED = 2'b11;

    // Sequential logic for state transitions
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (request) begin
                        state <= REQUEST_RECEIVED;
                    end
                end
                REQUEST_RECEIVED: begin
                    if (data_ready) begin
                        state <= DATA_TRANSFER;
                    end
                end
                DATA_TRANSFER: begin
                    state <= COMPLETED;
                end
                COMPLETED: begin
                    state <= IDLE; // Go back to IDLE after completing
                end
            endcase
        end
    end
endmodule