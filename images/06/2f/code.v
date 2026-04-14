module interrupt_controller (
    input wire hpi,
    input wire lpi,
    input wire ack,
    output reg irq,
    output reg [1:0] irq_type
);
    
    always @(posedge hpi or posedge lpi or posedge ack) begin
        if (ack) begin
            irq <= 0;
            irq_type <= 2'b00;
        end else if (hpi) begin
            irq <= 1;
            irq_type <= 2'b01; // High-priority interrupt
        end else if (lpi) begin
            irq <= 1;
            irq_type <= 2'b10; // Low-priority interrupt
        end else begin
            irq <= 0;
            irq_type <= 2'b00; // No interrupt
        end
    end
endmodule