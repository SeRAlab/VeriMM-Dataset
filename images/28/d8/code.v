module sd_card_cmd_handler (
    input wire clk,
    input wire [1:0] cmd,
    output reg [7:0] resp
);

    reg [1:0] state;
    reg [1:0] next_state;

    localparam IDLE = 2'b00;
    localparam BUSY = 2'b01;
    localparam RESPOND = 2'b10;

    // State machine to handle command responses
    always @(posedge clk) begin
        state <= next_state;
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (cmd != 2'b00) begin
                    next_state = BUSY;
                end else begin
                    next_state = IDLE;
                end
            end
            BUSY: begin
                next_state = RESPOND;
            end
            RESPOND: begin
                case (cmd)
                    2'b00: resp = 8'h01; // Response for command 0
                    2'b01: resp = 8'h02; // Response for command 1
                    2'b10: resp = 8'h03; // Response for command 2
                    2'b11: resp = 8'h04; // Response for command 3
                    default: resp = 8'hFF; // Unknown command
                endcase
                next_state = IDLE; // Go back to idle after responding
            end
            default: next_state = IDLE;
        endcase
    end

endmodule