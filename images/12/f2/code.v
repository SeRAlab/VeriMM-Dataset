module sata_controller (
    input clk,
    input reset,
    input start,
    input suspend,
    input resume,
    input stop,
    output reg [1:0] state
);

    localparam IDLE = 2'b00;
    localparam ACTIVE = 2'b01;
    localparam SUSPEND = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= ACTIVE;
                end
                ACTIVE: begin
                    if (suspend) state <= SUSPEND;
                    else if (stop) state <= IDLE;
                end
                SUSPEND: begin
                    if (resume) state <= ACTIVE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule