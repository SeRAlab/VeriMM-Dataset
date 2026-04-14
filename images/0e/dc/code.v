module sd_card_command_decoder (
    input [3:0] command,
    output reg [2:0] response
);

always @(*) begin
    case (command)
        4'b0000: response = 3'b001; // Command 0
        4'b0001: response = 3'b010; // Command 1
        4'b0010: response = 3'b011; // Command 2
        4'b0011: response = 3'b100; // Command 3
        4'b0100: response = 3'b101; // Command 4
        default: response = 3'b000;  // Default response
    endcase
end

endmodule