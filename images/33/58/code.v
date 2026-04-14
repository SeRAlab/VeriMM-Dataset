module sata_controller (
    input clk,
    input reset,
    input go_active,
    input go_suspend,
    output reg [1:0] state
);
    // State encoding
    localparam IDLE = 2'b00,
               ACTIVE = 2'b01,
               SUSPEND = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (go_active) state <= ACTIVE;
                end
                ACTIVE: begin
                    if (go_suspend) state <= SUSPEND;
                end
                SUSPEND: begin
                    if (go_active) state <= ACTIVE;
                    else if (go_suspend) state <= IDLE;
                end
            endcase
        end
    end
endmodule