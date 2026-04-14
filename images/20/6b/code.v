module data_forwarding (
    input wire [3:0] A,
    input wire [3:0] B,
    input wire Sel,
    output wire [3:0] Y
);
    assign Y = (Sel == 1'b0) ? A : B;
endmodule