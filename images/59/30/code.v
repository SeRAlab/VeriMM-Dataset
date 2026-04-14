module top_module(
    input [1:0] count_i,
    input op,
    output reg [1:0] count  // Change 'wire' to 'reg'
);always @*
    begin
        case (count_i)
            2'b00: count = op ? 2'b01 : 2'b00;
            2'b01: count = op ? 2'b10 : 2'b00;
            2'b10: count = op ? 2'b10 : 2'b01;
            2'b11: count = op ? 2'b11 : 2'b10;
            default: count = 2'b00; // Add default case for safety
        endcase
    end

endmodule