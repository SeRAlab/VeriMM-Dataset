module T_latch (
    input wire T,          // Toggle input
    input wire clk,       // Clock input
    output reg Q          // Output
);
    always @(posedge clk) begin
        if (T) begin
            Q <= ~Q;      // Toggle the output
        end
    end
endmodule