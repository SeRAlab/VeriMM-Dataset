module sd_card_interface (
    input [3:0] command,
    output reg [3:0] response
);
    always @(*) begin
        case (command)
            4'b0000: response = 4'b1111; // Read command
            4'b0001: response = 4'b1110; // Write command
            default: response = 4'b0000;  // Other commands
        endcase
    end
endmodule