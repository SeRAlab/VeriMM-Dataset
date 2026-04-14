module mux4to1 (
        input d0,
        input d1,
        input d2,
        input d3,
        input [1:0] sel,
        output y);

    assign y = (sel == 2'b00) ? d0 :
               (sel == 2'b01) ? d1 :
               (sel == 2'b10) ? d2 :
               d3;

endmodule