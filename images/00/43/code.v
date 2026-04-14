module sd_card_interface (
    input [3:0] command,
    output reg [3:0] response
);

always @(*) begin
    case (command)
        4'b0000: response = 4'b0001; // Command 0
        4'b0001: response = 4'b0010; // Command 1
        4'b0010: response = 4'b0011; // Command 2
        4'b0011: response = 4'b0100; // Command 3
        default: response = 4'b0000;  // Commands 4 to 15
    endcase
end

endmodule