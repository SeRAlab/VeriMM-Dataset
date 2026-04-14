module pcie_endpoint_controller (
    input clk,
    input reset,
    input start,
    input complete,
    input error,
    output reg [1:0] state
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam DATA = 2'b01;
    localparam ERROR = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) 
                        state <= DATA;
                end
                DATA: begin
                    if (complete)
                        state <= IDLE;
                    else if (error)
                        state <= ERROR;
                end
                ERROR: begin
                    if (reset)
                        state <= IDLE;
                end
            endcase
        end
    end
endmodule