module pcie_sm (
    input wire clk,
    input wire reset,
    input wire start,
    input wire config_done,
    input wire error,
    output reg [1:0] state
);
    // State encoding
    localparam IDLE = 2'b00,
               CONFIG = 2'b01,
               DATA = 2'b10,
               ERROR = 2'b11;

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= CONFIG;
                end
                CONFIG: begin
                    if (config_done) state <= DATA;
                    else if (error) state <= ERROR;
                end
                DATA: begin
                    if (error) state <= ERROR;
                end
                ERROR: begin
                    if (reset) state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule