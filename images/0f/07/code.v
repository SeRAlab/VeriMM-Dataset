module interrupt_controller (
    input wire clk,
    input wire reset,
    input wire [3:0] irq,
    input wire enable,
    output reg [3:0] active_irq,
    output reg interrupt_request
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            active_irq <= 4'b0000;
            interrupt_request <= 0;
        end else if (enable) begin
            if (|irq) begin
                active_irq <= irq;
                interrupt_request <= 1;
            end else begin
                interrupt_request <= 0;
            end
        end else begin
            interrupt_request <= 0;
        end
    end
endmodule