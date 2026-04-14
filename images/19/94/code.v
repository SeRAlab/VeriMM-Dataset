module bluetooth_status_checker (
    input [2:0] status,
    output reg [31:0] message
);
    always @(*) begin
        case(status)
            3'b000: message = 32'h44495343; // "DISC"
            3'b001: message = 32'h434f4e4e; // "CONN"
            3'b010: message = 32'h434e4354; // "CNCT"
            default: message = 32'h00000000; // Default case
        endcase
    end
endmodule