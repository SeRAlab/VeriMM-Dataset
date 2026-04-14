module washing_machine (
    input clk,
    input areset,
    input start,
    output reg [1:0] state);

    parameter IDLE = 2'b00, WASHING = 2'b01, SPINNING = 2'b10;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (start) state <= WASHING;
                WASHING: state <= SPINNING;
                SPINNING: state <= IDLE;
                default: state <= IDLE;
            endcase
        end
    end
endmodule