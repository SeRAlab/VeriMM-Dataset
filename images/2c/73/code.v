module sd_card_controller (
    input [3:0] command,
    output reg [3:0] response
);

always @(*) begin
    case (command)
        4'b0000: response = 4'b1111; // Command 0000 -> Response 1111
        4'b0001: response = 4'b1110; // Command 0001 -> Response 1110
        4'b0010: response = 4'b1101; // Command 0010 -> Response 1101
        4'b0011: response = 4'b1100; // Command 0011 -> Response 1100
        default: response = 4'b0000;  // Any other command -> Response 0000
    endcase
end

endmodule