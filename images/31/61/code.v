module pcie_endpoint_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire done,
    output reg [1:0] state, // 00: IDLE, 01: TRANSFER, 10: DONE
    output reg transfer_in_progress
);
    // State encoding
    parameter IDLE = 2'b00;
    parameter TRANSFER = 2'b01;
    parameter DONE = 2'b10;

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            transfer_in_progress <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= TRANSFER;
                        transfer_in_progress <= 1;
                    end
                end
                TRANSFER: begin
                    if (done) begin
                        state <= DONE;
                        transfer_in_progress <= 0;
                    end
                end
                DONE: begin
                    state <= IDLE;
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule