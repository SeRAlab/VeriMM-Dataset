module pcie_sm (
    input clk,
    input reset,
    input req,
    input grant,
    input complete,
    output reg [1:0] state // 2'b00 = IDLE, 2'b01 = REQUEST, 2'b10 = RESPONSE
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter REQUEST = 2'b01;
    parameter RESPONSE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE; // Reset to IDLE state
        end else begin
            case (state)
                IDLE: begin
                    if (req) begin
                        state <= REQUEST; // Go to REQUEST state
                    end
                end
                REQUEST: begin
                    if (grant) begin
                        state <= RESPONSE; // Go to RESPONSE state
                    end
                end
                RESPONSE: begin
                    if (complete) begin
                        state <= IDLE; // Go back to IDLE state
                    end
                end
            endcase
        end
    end

endmodule