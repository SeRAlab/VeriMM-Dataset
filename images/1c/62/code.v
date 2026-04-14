module pcie_endpoint_controller (
    input clk,
    input reset,
    input start,
    input request_done,
    input timeout,
    output reg [1:0] state // 2-bit state representation
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter REQUEST = 2'b01;
    parameter ACKNOWLEDGE = 2'b10;

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
                    if (request_done) begin
                        state <= ACKNOWLEDGE;
                    end
                end
                
                ACKNOWLEDGE: begin
                    if (timeout) begin
                        state <= IDLE;
                    end
                end
                
                default: state <= IDLE; // Default case
            endcase
        end
    end
endmodule