module sata_controller (
    input [4:0] command,
    output reg [2:0] status
);

always @(*) begin
    case (command)
        5'b00000: status = 3'b000; // Idle
        5'b00001: status = 3'b001; // Ready
        5'b00010: status = 3'b010; // Processing
        5'b00011: status = 3'b011; // Completed
        5'b00100: status = 3'b100; // Error
        default:  status = 3'b111; // Unknown
    endcase
end

endmodule