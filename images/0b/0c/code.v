module pcie_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire done,
    input wire [15:0] data_in,
    output reg [15:0] data_out,
    output reg state // 0: IDLE, 1: TRANSMITTING, 2: COMPLETE
);
    parameter IDLE = 0, TRANSMITTING = 1, COMPLETE = 2;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            data_out <= 16'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= TRANSMITTING;
                        data_out <= data_in;
                    end
                end
                TRANSMITTING: begin
                    if (done) begin
                        state <= COMPLETE;
                    end
                end
                COMPLETE: begin
                    // Wait for the next start signal
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule