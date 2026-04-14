module pcie_endpoint_controller (
    input [4:0] command,
    output reg [2:0] status
);

always @(*) begin
    case (command)
        5'b00000: status = 3'b000; // Command 0
        5'b00001: status = 3'b001; // Command 1
        5'b00010: status = 3'b010; // Command 2
        5'b00011: status = 3'b011; // Command 3
        5'b00100: status = 3'b100; // Command 4
        default:  status = 3'b101; // Invalid command
    endcase
end

endmodule