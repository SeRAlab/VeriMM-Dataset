module pcie_endpoint_controller (
    input wire clk,
    input wire rst,
    input wire req,
    input wire err,
    output reg [1:0] state
);
    parameter IDLE = 2'b00, ACTIVE = 2'b01, ERROR = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (req) begin
                        state <= ACTIVE;
                    end
                end
                ACTIVE: begin
                    if (err) begin
                        state <= ERROR;
                    end
                end
                ERROR: begin
                    if (~err) begin
                        state <= IDLE;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule