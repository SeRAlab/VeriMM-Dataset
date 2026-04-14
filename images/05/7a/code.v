module nvme_command_decoder(
    input [4:0] opcode,
    output reg [2:0] command_type
);

always @(*) begin
    case (opcode)
        5'b00000: command_type = 3'b001; // Read
        5'b00001: command_type = 3'b010; // Write
        5'b00010: command_type = 3'b011; // Ident
        5'b00011: command_type = 3'b000; // Reserved
        5'b00100: command_type = 3'b000; // Reserved
        default:   command_type = 3'b111; // Invalid
    endcase
end

endmodule