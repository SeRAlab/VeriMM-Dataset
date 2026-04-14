module mux2bit4to1 (
    input wire [1:0] sel,
    input wire [7:0] d,
    output wire [1:0] y
);

    assign y = (sel == 2'b00) ? d[1:0] :
               (sel == 2'b01) ? d[3:2] :
               (sel == 2'b10) ? d[5:4] :
               d[7:6];

endmodule