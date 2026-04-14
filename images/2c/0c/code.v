module nvme_controller (
    input wire clk,
    input wire rst,
    input wire start,
    output reg [1:0] state // 00: idle, 01: processing, 10: completed
);
    // State encoding
    localparam IDLE = 2'b00,
               PROCESSING = 2'b01,
               COMPLETED = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (start) state <= PROCESSING;
                PROCESSING: state <= COMPLETED;
                COMPLETED: state <= IDLE;
                default: state <= IDLE;
            endcase
        end
    end
endmodule