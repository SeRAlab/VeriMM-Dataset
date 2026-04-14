module top_module(
    input J,
    input K,
    input CP,
    input MR,
    output reg Q
);always @(posedge CP or posedge MR) begin
        if (MR)
            Q <= 0; // Clear
        else begin
            case ({J, K})
                2'b00: Q <= Q;      // No change
                2'b01: Q <= 1;      // Set
                2'b10: Q <= 0;      // Reset
                2'b11: Q <= ~Q;     // Toggle
            endcase
        end
    end
endmodule