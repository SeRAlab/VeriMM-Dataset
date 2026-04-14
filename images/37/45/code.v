module sd_card_command_decoder (
    input [3:0] command,
    output reg [2:0] response
);

always @(*) begin
    case (command)
        4'b0000: response = 3'b001;
        4'b0001: response = 3'b010;
        4'b0010: response = 3'b011;
        4'b0011: response = 3'b100;
        4'b0100: response = 3'b101;
        default: response = 3'b000;
    endcase
end

endmodule