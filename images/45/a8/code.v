module top_module(
    input wire[15:0] iAddress,
    output reg[27:0] oInstruction
);reg[27:0] rom[0:15];

initial begin
    rom[0] = {8'b10101010, 20'b0}; // NOP
    rom[1] = {8'b00000001, 4'b0, 4'b111, 12'b0}; // STO R7, 1
    rom[2] = {8'b00000001, 4'b0, 4'b011, 12'b1}; // STO R3, 1
    rom[3] = {8'b00000001, 4'b0, 4'b100, 12'b1000}; // STO R4, 1000
    rom[4] = {8'b00000001, 4'b0, 4'b101, 12'b0}; // STO R5, 0
    rom[5] = {8'b00000101, 8'b0, 4'b111, 8'b0}; // LED R7
    rom[6] = {8'b00000001, 4'b0, 4'b001, 12'b0}; // STO R1, 0
    rom[7] = {8'b00000001, 4'b0, 4'b010, 12'b101000000000}; // STO R2, 5000
    rom[8] = {8'b00000010, 4'b0, 4'b001, 4'b011, 4'b000}; // ADD R1, R1, R3
    rom[9] = {8'b00000100, 4'b0, 4'b000, 4'b001, 8'b11111110}; // BLE LOOP1, R1, R2
    rom[10] = {8'b00000010, 4'b0, 4'b101, 4'b101, 4'b011}; // ADD R5, R5, R3
    rom[11] = {8'b00000100, 4'b0, 4'b000, 4'b101, 8'b11111110}; // BLE LOOP2, R5, R4
    rom[12] = {8'b10101010, 20'b0}; // NOP
    rom[13] = {8'b00000110, 4'b0, 4'b111, 4'b011}; // SUB R7, R7, R3
    rom[14] = {8'b00000111, 8'b0, 8'b0, 8'b00000010}; // JMP 2
    rom[15] = {8'b10101010, 20'b0}; // NOP
end

always @(iAddress) begin
    oInstruction <= rom[iAddress];
end

endmodule