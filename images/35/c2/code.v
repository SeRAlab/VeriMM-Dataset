module pcie_controller (
    input clk,
    input reset,
    input req,
    output reg rsp
);

    reg [2:0] state;
    
    parameter IDLE = 3'b000, REQUEST = 3'b001, RESPONSE = 3'b010;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            rsp <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (req) begin
                        state <= REQUEST;
                    end
                end
                REQUEST: begin
                    state <= RESPONSE;
                end
                RESPONSE: begin
                    rsp <= 1; // Generate response
                    state <= IDLE; // Go back to IDLE
                end
            endcase
        end
    end
endmodule