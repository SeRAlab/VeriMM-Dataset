module interrupt_controller (
    input wire clk,
    input wire rst,
    input wire [3:0] irq_in,
    output reg [3:0] irq_out
);
    reg [1:0] state; // 0: Idle, 1: IRQ0, 2: IRQ1, 3: IRQ2, 4: IRQ3

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            irq_out <= 4'b0000; // Clear output on reset
            state <= 2'b00; // Idle state
        end else begin
            case (state)
                2'b00: begin // Idle state
                    if (irq_in[3]) begin
                        irq_out <= 4'b1000; // Service IRQ3
                        state <= 2'b11;
                    end else if (irq_in[2]) begin
                        irq_out <= 4'b0100; // Service IRQ2
                        state <= 2'b10;
                    end else if (irq_in[1]) begin
                        irq_out <= 4'b0010; // Service IRQ1
                        state <= 2'b01;
                    end else if (irq_in[0]) begin
                        irq_out <= 4'b0001; // Service IRQ0
                        state <= 2'b00;
                    end else begin
                        irq_out <= 4'b0000; // No IRQ
                    end
                end
                default: begin
                    if (irq_out != 4'b0000) begin
                        irq_out <= 4'b0000; // Clear IRQ output after servicing
                    end
                    state <= 2'b00; // Return to idle after servicing
                end
            endcase
        end
    end
endmodule