module sr_flip_flop (
    input wire S,
    input wire R,
    input wire reset,
    input wire clk,
    output reg Q
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= 0;
        end else begin
            case ({S, R})
                2'b00: Q <= Q;      // Hold state
                2'b01: Q <= 0;      // Reset
                2'b10: Q <= 1;      // Set
                2'b11: Q <= 1'bx;   // Invalid state (undefined)
            endcase
        end
    end
endmodule