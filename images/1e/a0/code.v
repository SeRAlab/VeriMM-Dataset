module sata_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire stop,
    input wire error,
    output reg [1:0] state
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam ACTIVE = 2'b01;
    localparam ERROR = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= ACTIVE;
                end
                ACTIVE: begin
                    if (stop) state <= IDLE;
                    else if (error) state <= ERROR;
                end
                ERROR: begin
                    if (reset) state <= IDLE;
                end
            endcase
        end
    end
endmodule