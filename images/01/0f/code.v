module pcie_endpoint_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire ack,
    output reg [1:0] state
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam REQUEST = 2'b01;
    localparam ACK = 2'b10;

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
                    if (ack) begin
                        state <= ACK;
                    end
                end
                ACK: begin
                    state <= IDLE; // Transition back to IDLE
                end
                default: state <= IDLE; // Default case
            endcase
        end
    end
endmodule