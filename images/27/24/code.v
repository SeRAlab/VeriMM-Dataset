module bluetooth_status_checker (
    input [1:0] status,
    output reg [2:0] encoded_status
);
    always @(*) begin
        case (status)
            2'b00: encoded_status = 3'b000; // Off
            2'b01: encoded_status = 3'b001; // Connecting
            2'b10: encoded_status = 3'b010; // Connected
            2'b11: encoded_status = 3'b111; // Error
            default: encoded_status = 3'bxxx; // Undefined
        endcase
    end
endmodule