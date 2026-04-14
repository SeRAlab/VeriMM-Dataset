module interrupt_controller(
    input wire clk,
    input wire rst_n,
    input wire [2:0] irq,
    input wire ack,
    output reg [2:0] int_out
);
    reg [2:0] irq_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            int_out <= 3'b000;
            irq_reg <= 3'b000;
        end else begin
            irq_reg <= irq;
            if (ack) begin
                int_out <= 3'b000; // Acknowledge resets the output
            end else begin
                if (irq_reg[0]) begin
                    int_out <= 3'b001; // irq[0] is active
                end else if (irq_reg[1]) begin
                    int_out <= 3'b010; // irq[1] is active
                end else if (irq_reg[2]) begin
                    int_out <= 3'b100; // irq[2] is active
                end else begin
                    int_out <= 3'b000; // No interrupt active
                end
            end
        end
    end
endmodule