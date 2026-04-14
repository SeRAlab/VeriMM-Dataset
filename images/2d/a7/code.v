module sd_card_interface (
    input [1:0] command,
    output reg [7:0] response
);

    always @(*) begin
        case (command)
            2'b00: response = "IDLE";
            2'b01: response = "READ";
            2'b10: response = "WRITE";
            default: response = "IDLE"; // Default to IDLE on invalid input
        endcase
    end
endmodule