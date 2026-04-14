module mux2to1 (
    input wire D0,
    input wire D1,
    input wire S,
    output wire Y
);
    assign Y = (S) ? D1 : D0;
endmodule