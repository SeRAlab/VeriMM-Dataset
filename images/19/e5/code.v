module nvme_command_decoder (
    input [4:0] command,
    output reg [2:0] command_type
);

always @(*) begin
    case (command[2:0]) // Only the lower 3 bits are used for command type
        3'b000: command_type = 3'b000; // Read Command
        3'b001: command_type = 3'b001; // Write Command
        3'b010: command_type = 3'b010; // Flush Command
        3'b011: command_type = 3'b011; // Invalid Command
        default: command_type = 3'b100; // Other Commands
    endcase
end

endmodule