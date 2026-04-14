module top_module(
    input clk,
    input reset,
    input trigger,
    output reg pulse_out);reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            pulse_out <= 0;
        end else begin
            case (state)
                2'b00: if (trigger) state <= 2'b01;
                2'b01: begin
                    pulse_out <= 1;
                    state <= 2'b10;
                end
                2'b10: begin
                    pulse_out <= 0;
                    state <= 2'b00;
                end
            endcase
        end
    end

endmodule