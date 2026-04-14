module sd_card_interface (
    input [3:0] command,
    output reg [2:0] response
);
    always @(*) begin
        case (command)
            4'b0000: response = 3'b000; // 0
            4'b0001: response = 3'b001; // 1
            4'b0010: response = 3'b010; // 2
            4'b0011: response = 3'b011; // 3
            default: response = 3'b111;   // invalid
        endcase
    end
endmodule