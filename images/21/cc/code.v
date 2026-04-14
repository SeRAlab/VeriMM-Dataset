module interrupt_controller (
    input wire clk,
    input wire rst,
    input wire intA,
    input wire intB,
    output reg irq
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            irq <= 0;
        end else begin
            if (intA) begin
                irq <= 1; // Type A interrupt takes priority
            end else if (intB) begin
                irq <= 1; // Type B interrupt
            end else begin
                irq <= 0; // No interrupt
            end
        end
    end
endmodule