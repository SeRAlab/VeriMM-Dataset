module decision_tree (
    input wire A,
    input wire B,
    output reg [1:0] classified
);

always @(*) begin
    case ({A, B})
        2'b00: classified = 2'b00; // A=0, B=0
        2'b01: classified = 2'b01; // A=0, B=1
        2'b10: classified = 2'b10; // A=1, B=0
        2'b11: classified = 2'b11; // A=1, B=1
        default: classified = 2'b00; // Default case (should never happen)
    endcase
end

endmodule