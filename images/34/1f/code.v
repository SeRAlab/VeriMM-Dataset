module interrupt_controller (
    input wire clk,
    input wire rst,
    input wire [3:0] irq,       // Interrupt request inputs
    input wire [1:0] prty,      // Priority of the interrupt
    output reg ack              // Acknowledge output
);
    reg [1:0] current_priority;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ack <= 0;
            current_priority <= 2'b11; // Initialize to lowest priority
        end else begin
            if (irq != 4'b0000 && ack == 0) begin
                if (prty < current_priority) begin
                    ack <= 1; // Acknowledge the interrupt
                    current_priority <= prty; // Update current priority
                end
            end
            else begin
                ack <= 0; // Deactivate ack if no irq or already acknowledged
            end
        end
    end
endmodule