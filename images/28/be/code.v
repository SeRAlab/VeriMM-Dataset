module T_latch (
    input wire T,
    input wire R,
    output reg Q
);
    always @(posedge T or posedge R) begin
        if (R) begin
            Q <= 0; // Asynchronous reset
        end else begin
            Q <= ~Q; // Toggle operation
        end
    end
endmodule