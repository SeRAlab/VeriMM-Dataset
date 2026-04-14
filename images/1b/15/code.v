module pcie_endpoint_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire error,
    output reg [1:0] state
);

    localparam IDLE = 2'b00;
    localparam ACTIVE = 2'b01;
    localparam ERROR = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= ACTIVE;
                    end
                end
                ACTIVE: begin
                    if (error) begin
                        state <= ERROR;
                    end
                end
                ERROR: begin
                    if (!error) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule