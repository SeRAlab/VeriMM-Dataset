module pcie_endpoint_controller (
    input clk,
    input reset,
    input start,
    input ready,
    input done,
    output reg [1:0] state // 2-bit state encoding: 00 - IDLE, 01 - REQUEST, 10 - RESPONSE
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam REQUEST = 2'b01;
    localparam RESPONSE = 2'b10;

    // Sequential logic for state transitions
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= REQUEST;
                    end
                end
                REQUEST: begin
                    if (ready) begin
                        state <= RESPONSE;
                    end
                end
                RESPONSE: begin
                    if (done) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule