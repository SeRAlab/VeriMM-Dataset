module sd_card_decoder (
    input [3:0] command,
    output reg [1:0] operation
);
    always @(*) begin
        case (command)
            4'b0001: operation = 2'b01; // Read Request
            4'b0010: operation = 2'b10; // Write Request
            4'b0011: operation = 2'b11; // Erase Request
            4'b0100: operation = 2'b00; // Initialize Request
            default: operation = 2'b00;   // No Operation
        endcase
    end
endmodule