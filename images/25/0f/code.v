module interrupt_controller (
    input wire clk,
    input wire reset,
    input wire high_priority_interrupt,
    input wire low_priority_interrupt,
    output reg interrupt_serviced
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            interrupt_serviced <= 0;
        end else if (high_priority_interrupt) begin
            interrupt_serviced <= 1;
        end else if (low_priority_interrupt) begin
            interrupt_serviced <= 1;
        end else begin
            interrupt_serviced <= 0;
        end
    end
endmodule