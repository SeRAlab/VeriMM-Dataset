module sata_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire error,
    output reg [1:0] state
);

    // State encoding
    parameter IDLE = 2'b00, ACTIVE = 2'b01, ERROR = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= ACTIVE;
                end
                ACTIVE: begin
                    if (error) state <= ERROR;
                end
                ERROR: begin
                    if (!error) state <= IDLE; // Reset to IDLE if no error
                end
            endcase
        end
    end
endmodule