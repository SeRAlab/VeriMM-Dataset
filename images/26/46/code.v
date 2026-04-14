module T_latch (
    input wire T,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (T) begin
            Q <= ~Q; // Toggle the output
        end
        // If T is low, Q holds its value
    end
endmodule