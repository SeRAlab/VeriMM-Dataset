module interrupt_controller(
    input wire clk,
    input wire reset,
    input wire enable,
    input wire interrupt_request,
    output reg interrupt_accepted
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            interrupt_accepted <= 0;
        end else if (enable && interrupt_request) begin
            interrupt_accepted <= 1;
        end else begin
            interrupt_accepted <= 0;
        end
    end
endmodule