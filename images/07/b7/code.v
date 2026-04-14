module interrupt_controller (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire interrupt_request,
    output reg interrupt_ack
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            interrupt_ack <= 0;
        end else if (enable && interrupt_request) begin
            interrupt_ack <= 1;
        end else begin
            interrupt_ack <= 0;
        end
    end
endmodule