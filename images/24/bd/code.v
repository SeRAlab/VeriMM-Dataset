module mux_data_forwarding (
    input wire A,
    input wire B,
    input wire Sel,
    output wire Y
);
    assign Y = Sel ? B : A;
endmodule