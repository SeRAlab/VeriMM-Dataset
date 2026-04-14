module nvme_command_decoder(
    input [3:0] command,
    output reg [2:0] command_type
);
    always @(*) begin
        case (command)
            4'b0000: command_type = 3'b000; // Command 0
            4'b0001: command_type = 3'b001; // Command 1
            4'b0010: command_type = 3'b010; // Command 2
            4'b0011: command_type = 3'b011; // Command 3
            4'b0100: command_type = 3'b100; // Command 4
            4'b0101: command_type = 3'b101; // Command 5
            4'b0110: command_type = 3'b110; // Command 6
            4'b0111: command_type = 3'b111; // Command 7
            default: command_type = 3'b111;  // Command 8 or higher
        endcase
    end
endmodule