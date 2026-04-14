module top_module(
    input [1:0] coin,
    input [1:0] item,
    input dispense,
    output reg vend
);always @(*) begin
        case (item)
            2'b00: vend = 0; // No item selected
            2'b01: vend = (coin >= 2'b01) && dispense; // Item A costs 5 cents
            2'b10: vend = (coin >= 2'b10) && dispense; // Item B costs 10 cents
            2'b11: vend = (coin >= 2'b11) && dispense; // Item C costs 15 cents
        endcase
    end

endmodule