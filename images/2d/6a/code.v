module interrupt_controller (
    input wire clk,
    input wire int1,
    input wire int2,
    input wire int3,
    output reg irq
);
    always @(posedge clk) begin
        if (int1 || int2 || int3) 
            irq <= 1;
        else 
            irq <= 0;
    end
endmodule