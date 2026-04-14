module bluetooth_command_decoder (
    input [3:0] command,
    output reg [2:0] status
);

always @(*) begin
    case (command)
        4'b0000: status = 3'b000; // Command 0
        4'b0001: status = 3'b001; // Command 1
        4'b0010: status = 3'b010; // Command 2
        4'b0011: status = 3'b011; // Command 3
        4'b0100: status = 3'b100; // Command 4
        default: status = 3'b101;  // All other commands
    endcase
end

endmodule