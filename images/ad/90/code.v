module top_module(
    input CLK,
    input LOAD,
    input UP,
    input DOWN,
    output reg [3:0] Q
);always @(posedge CLK) begin
        case ({UP, DOWN})
            2'b00: Q <= Q - 1; // Count down
            2'b01: Q <= Q + 1; // Count up
            2'b10: Q <= Q;     // Hold current value
            2'b11: Q <= Q;     // Hold current value
        endcase
        if (LOAD) Q <= 4'b0000; // Load data if LOAD is high
    end

endmodule