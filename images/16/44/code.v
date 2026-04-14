module FlashMemoryCell (
    input wire CLK,
    input wire D,
    input wire P,
    input wire E,
    input wire R,
    output reg Q
);
    always @(posedge CLK) begin
        if (E) begin
            Q <= 0; // Erase
        end else if (P) begin
            Q <= D; // Program
        end else if (R) begin
            Q <= Q; // Read (retains value)
        end
    end
endmodule