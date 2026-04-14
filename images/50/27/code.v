module top_module(
    input clear, switch, clock,
    output reg request
);reg [1:0] state;
    parameter state_a = 2'b00, state_b = 2'b01, state_c = 2'b10;

    always @(posedge clock) begin
        if (clear) begin
            state <= state_a;
            request <= 0;
        end
        else begin
            case (state)
                state_a:
                    if (switch) begin
                        state <= state_b;
                    end
                state_b:
                    if (!switch) begin
                        state <= state_c;
                    end
                state_c:
                    if (switch) begin
                        state <= state_a;
                        request <= 1;
                    end
            endcase
        end
    end

endmodule