module mux4to1 (
    input wire A,
    input wire B,
    input wire C,
    input wire D,
    input wire [1:0] S,
    output wire Y
);
    assign Y = (S == 2'b00) ? A :
               (S == 2'b01) ? B :
               (S == 2'b10) ? C :
               (S == 2'b11) ? D : 1'b0; // Default case to avoid latches
endmodule