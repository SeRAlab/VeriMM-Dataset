module interrupt_controller (
    input clk,
    input reset,
    input IRQ0,
    input IRQ1,
    input IRQ2,
    input ack,
    output reg INT
);
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            INT <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin
                    if (IRQ0) begin
                        INT <= 1;
                        state <= 1;
                    end else if (IRQ1) begin
                        INT <= 1;
                        state <= 2;
                    end else if (IRQ2) begin
                        INT <= 1;
                        state <= 3;
                    end
                end
                1: begin
                    if (ack) begin
                        INT <= 0;
                        state <= 0;
                    end
                end
                2: begin
                    if (ack) begin
                        INT <= 0;
                        state <= 0;
                    end
                end
                3: begin
                    if (ack) begin
                        INT <= 0;
                        state <= 0;
                    end
                end
            endcase
        end
    end
endmodule