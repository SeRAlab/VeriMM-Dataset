module pcie_endpoint_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire done,
    output reg [1:0] state // 00: IDLE, 01: TRANSFER, 10: COMPLETE
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter TRANSFER = 2'b01;
    parameter COMPLETE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= TRANSFER;
                end
                TRANSFER: begin
                    if (done) state <= COMPLETE;
                end
                COMPLETE: begin
                    state <= IDLE; // Reset to IDLE after completion
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule