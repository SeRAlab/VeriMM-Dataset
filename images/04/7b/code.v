module pcie_sm (
    input clk,
    input reset,
    input req,
    input ack,
    output reg [1:0] state, // 00 - IDLE, 01 - REQUEST, 10 - RESPONSE, 11 - ERROR
    output reg transaction_success
);
    
    // State encoding
    localparam IDLE = 2'b00;
    localparam REQUEST = 2'b01;
    localparam RESPONSE = 2'b10;
    localparam ERROR = 2'b11;

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            transaction_success <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (req) begin
                        state <= REQUEST;
                    end
                end

                REQUEST: begin
                    if (ack) begin
                        state <= RESPONSE;
                        transaction_success <= 1'b1; // Transaction successful
                    end else begin
                        state <= ERROR;
                    end
                end

                RESPONSE: begin
                    state <= IDLE; // Go back to IDLE after response
                end

                ERROR: begin
                    state <= IDLE; // Go back to IDLE on error
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule