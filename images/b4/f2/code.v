module mux4to1 (
    input wire [1:0] sel,
    input wire [3:0] d,
    output wire y
);

    assign y = (sel == 2'b00) ? d[0] :
               (sel == 2'b01) ? d[1] :
               (sel == 2'b10) ? d[2] :
               d[3];

endmodule