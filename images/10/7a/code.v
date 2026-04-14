module T_latch (
    input wire T,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (T) begin
            Q <= ~Q; // Toggle Q if T is high
        end
        // If T is low, Q remains the same
    end
endmodule