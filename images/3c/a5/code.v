module interrupt_controller (
    input wire clk,
    input wire reset,
    input wire [3:0] interrupts,
    output reg interrupt_ack
);
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            interrupt_ack <= 0;
            state <= 2'b00;
        end else begin
            case (state)
                2'b00: begin
                    if (interrupts != 4'b0000) begin
                        interrupt_ack <= 1;
                        state <= 2'b01;
                    end
                end
                2'b01: begin
                    interrupt_ack <= 0;
                    state <= 2'b00;
                end
            endcase
        end
    end
endmodule