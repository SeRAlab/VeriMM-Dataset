module T_latch (
    input wire T,
    input wire CLK,
    input wire EN,
    output reg Q
);
    always @(posedge CLK) begin
        if (EN) begin
            if (T) begin
                Q <= ~Q; // Toggle Q if T is high
            end
            // If T is low, Q remains the same
        end
    end
endmodule