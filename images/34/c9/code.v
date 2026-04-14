module flash_memory_cell (
    input [4:0] D,
    input SET,
    output reg [4:0] Q
);
    always @(*) begin
        if (SET) begin
            Q = D;
        end else begin
            Q = 5'b00000;
        end
    end
endmodule