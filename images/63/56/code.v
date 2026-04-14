module top_module(
    input [3:0] floor_num,
    input [1:0] direction,
    output reg [2:0] floor_select
);// Priority Encoder
    wire [2:0] priority_enc;
    assign priority_enc = ~(floor_num - 1);

    // Binary-to-Gray Code Converter
    wire [2:0] gray_code;
    assign gray_code[2] = priority_enc[2];
    assign gray_code[1] = priority_enc[2] ^ priority_enc[1];
    assign gray_code[0] = priority_enc[1] ^ priority_enc[0];

    // Binary-to-Decimal Decoder
    always @* begin
        case (gray_code)
            3'b000: floor_select = 3'b000;
            3'b001: floor_select = (direction == 2'b00) ? 3'b001 : 3'b000;
            3'b010: floor_select = (direction == 2'b00) ? 3'b010 : 3'b001;
            3'b011: floor_select = (direction == 2'b00) ? 3'b011 : 3'b010;
            3'b100: floor_select = (direction == 2'b10) ? 3'b100 : 3'b011;
            3'b101: floor_select = (direction == 2'b10) ? 3'b101 : 3'b100;
            3'b110: floor_select = (direction == 2'b10) ? 3'b110 : 3'b101;
            3'b111: floor_select = 3'b111;
        endcase
    end

endmodule