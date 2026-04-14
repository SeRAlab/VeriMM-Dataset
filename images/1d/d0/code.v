module pcie_interface (
    input clk,
    input reset,
    input start,
    input done,
    output reg [1:0] state // 00: IDLE, 01: TRANSFER, 10: DONE
);

    localparam IDLE = 2'b00;
    localparam TRANSFER = 2'b01;
    localparam DONE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case(state)
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
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule