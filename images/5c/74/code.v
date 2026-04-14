module door_lock (
    input clk,
    input areset,
    input key,
    input timeout,
    output reg [1:0] state);

    parameter LOCKED = 2'b00, UNLOCKED = 2'b01, WAITING = 2'b10;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= LOCKED;
        end else begin
            case (state)
                LOCKED: begin
                    if (key) state <= UNLOCKED;
                    else state <= LOCKED;
                end
                UNLOCKED: begin
                    if (!key) state <= WAITING;
                    else state <= UNLOCKED;
                end
                WAITING: begin
                    if (timeout) state <= LOCKED;
                    else state <= WAITING;
                end
            endcase
        end
    end
endmodule