module bluetooth_controller (
    input [1:0] command,
    output reg [2:0] status
);
    always @(*) begin
        case (command)
            2'b00: status = 3'b000;
            2'b01: status = 3'b001;
            2'b10: status = 3'b010;
            2'b11: status = 3'b011;
            default: status = 3'b100; // unrecognized command
        endcase
    end
endmodule