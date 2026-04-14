module bluetooth_controller (
    input [3:0] status,
    output reg [2:0] status_code
);

always @(*) begin
    case (status)
        4'b0000: status_code = 3'b000; // OFF
        4'b0001: status_code = 3'b001; // CONNECTING
        4'b0010: status_code = 3'b010; // CONNECTED
        4'b0011: status_code = 3'b011; // DISCONNECTED
        4'b0100: status_code = 3'b100; // ERROR
        default: status_code = 3'bxxx;  // Undefined
    endcase
end

endmodule