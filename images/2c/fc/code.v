module eeprom_cell(
    input [4:0] D,
    input Ctrl,
    output reg [4:0] Q
);
    always @(*) begin
        if (Ctrl) 
            Q = D;  // Store value
        else 
            Q = Q;  // Retain value
    end
endmodule