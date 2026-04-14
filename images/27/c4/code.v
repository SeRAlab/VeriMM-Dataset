module FlashMemoryCell (
    input wire D,
    input wire WE,
    output reg Q
);

always @(*) begin
    if (WE) begin
        Q = D;  // Write data D to Q when WE is high
    end
    // Q retains its value when WE is low (memory behavior)
end

endmodule