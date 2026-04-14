module sata_controller (
    input clk,
    input rst,
    input [1:0] command,
    output reg [1:0] state
);
    parameter IDLE = 2'b00, ACTIVE = 2'b01, SUSPEND = 2'b10, ERROR = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    case (command)
                        2'b00: state <= IDLE;
                        2'b01: state <= ACTIVE;
                        2'b10: state <= SUSPEND;
                        2'b11: state <= ERROR;
                    endcase
                end
                ACTIVE: begin
                    case (command)
                        2'b00: state <= IDLE;
                        2'b01: state <= ACTIVE;
                        2'b10: state <= SUSPEND;
                        2'b11: state <= ERROR;
                    endcase
                end
                SUSPEND: begin
                    case (command)
                        2'b00: state <= IDLE;
                        2'b01: state <= ACTIVE;
                        2'b10: state <= SUSPEND;
                        2'b11: state <= ERROR;
                    endcase
                end
                ERROR: begin
                    case (command)
                        2'b00: state <= IDLE;
                        2'b01: state <= ACTIVE;
                        2'b10: state <= SUSPEND;
                        2'b11: state <= ERROR;
                    endcase
                end
            endcase
        end
    end

endmodule