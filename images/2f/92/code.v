module sr_flip_flop (
    input wire S,
    input wire R,
    input wire clk,
    input wire reset,
    output reg Q,
    output reg Qn
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= 0;
            Qn <= 1;
        end else begin
            case ({S, R})
                2'b00: ; // No change
                2'b01: begin // Set
                    Q <= 1;
                    Qn <= 0;
                end
                2'b10: begin // Reset
                    Q <= 0;
                    Qn <= 1;
                end
                2'b11: ; // Invalid state, no change
            endcase
        end
    end
endmodule