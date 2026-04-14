module parking_gate (
    input clk,
    input areset,
    input sensor,
    input timer,
    output reg [1:0] state);

    parameter CLOSED = 2'b00, OPENING = 2'b01, OPEN = 2'b10, CLOSING = 2'b11;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= CLOSED;
        end else begin
            case (state)
                CLOSED: begin
                    if (sensor) state <= OPENING;
                    else state <= CLOSED;
                end
                OPENING: begin
                    state <= OPEN;
                end
                OPEN: begin
                    if (timer) state <= CLOSING;
                    else state <= OPEN;
                end
                CLOSING: begin
                    state <= CLOSED;
                end
            endcase
        end
    end
endmodule