module washing_machine (
    input clk,
    input areset,
    input start,
    input done,
    output reg [1:0] state);

    parameter IDLE = 2'b00, WASHING = 2'b01, RINSING = 2'b10, SPINNING = 2'b11;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= WASHING;
                    else state <= IDLE;
                end
                WASHING: begin
                    if (done) state <= RINSING;
                    else state <= WASHING;
                end
                RINSING: begin
                    if (done) state <= SPINNING;
                    else state <= RINSING;
                end
                SPINNING: begin
                    if (done) state <= IDLE;
                    else state <= SPINNING;
                end
            endcase
        end
    end
endmodule