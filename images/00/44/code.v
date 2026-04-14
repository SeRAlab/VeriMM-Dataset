module pcie_endpoint_controller (
    input wire clk,
    input wire rst,
    input wire start,
    input wire done,
    output reg [1:0] state // 00: IDLE, 01: TRANSFER, 10: DONE
);

    parameter IDLE = 2'b00;
    parameter TRANSFER = 2'b01;
    parameter DONE = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= TRANSFER;
                    end
                end
                TRANSFER: begin
                    if (done) begin
                        state <= DONE;
                    end
                end
                DONE: begin
                    state <= IDLE; // Reset to IDLE after DONE
                end
            endcase
        end
    end
endmodule