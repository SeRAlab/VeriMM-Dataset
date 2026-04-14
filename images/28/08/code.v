module decision_tree (
    input wire A,
    input wire B,
    output reg [1:0] Y
);

always @(*) begin
    case ({A, B})
        2'b00: Y = 2'b00; // A=0, B=0
        2'b01: Y = 2'b01; // A=0, B=1
        2'b10: Y = 2'b10; // A=1, B=0
        2'b11: Y = 2'b11; // A=1, B=1
        default: Y = 2'b00; // Default case
    endcase
end

endmodule