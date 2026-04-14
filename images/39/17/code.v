module JK_latch (
    input wire J,
    input wire K,
    input wire CLK,
    output reg Q,
    output reg Qn
);

always @(posedge CLK) begin
    case ({J, K})
        2'b00: begin
            // Do nothing, hold state
            Qn <= ~Q;
        end
        2'b01: begin
            Q <= 0; // Reset
            Qn <= 1;
        end
        2'b10: begin
            Q <= 1; // Set
            Qn <= 0;
        end
        2'b11: begin
            Q <= ~Q; // Toggle
            Qn <= ~Qn;
        end
    endcase
end

endmodule