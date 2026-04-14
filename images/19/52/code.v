module nvme_command_decoder (
    input [3:0] command,
    output reg [2:0] command_type
);

always @(*) begin
    case (command)
        4'b0000: command_type = 3'b000;
        4'b0001: command_type = 3'b001;
        4'b0010: command_type = 3'b010;
        4'b0011: command_type = 3'b011;
        4'b0100: command_type = 3'b100;
        4'b0101: command_type = 3'b101;
        4'b0110: command_type = 3'b110;
        4'b0111: command_type = 3'b111;
        default: command_type = 3'b111; // Invalid command
    endcase
end

endmodule