module decision_tree (
    input wire A,
    input wire B,
    output reg [1:0] out
);

always @(*) begin
    case ({A, B})
        2'b00: out = 2'b00; // A=0, B=0
        2'b01: out = 2'b01; // A=0, B=1
        2'b10: out = 2'b10; // A=1, B=0
        2'b11: out = 2'b11; // A=1, B=1
        default: out = 2'bxx; // undefined case
    endcase
end

endmodule