module pcie_sm (
    input wire clk,
    input wire reset,
    input wire start,
    input wire error,
    output reg [1:0] state
);
    parameter IDLE = 2'b00, ACTIVE = 2'b01, ERROR = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) 
                        state <= ACTIVE;
                end
                ACTIVE: begin
                    if (error) 
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