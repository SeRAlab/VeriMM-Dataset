module nvme_command_decoder (
    input [3:0] command,
    output reg [1:0] command_type
);

always @(*) begin
    case (command)
        4'b0000: command_type = 2'b00; // NOP
        4'b0001: command_type = 2'b01; // READ
        4'b0010: command_type = 2'b10; // WRITE
        4'b0011: command_type = 2'b11; // FLUSH
        4'b0100: command_type = 2'b10; // RESET
        default: command_type = 2'b11;  // INVALID
    endcase
end

endmodule