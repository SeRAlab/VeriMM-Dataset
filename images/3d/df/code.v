module flash_memory_cell (
    input wire D,
    input wire WE,
    output reg Q
);

always @(*) begin
    if (WE) 
        Q = D;  // Write operation
    else 
        Q = Q;  // Read operation (holds the previous value)
end

endmodule