module mux4to1_4bit(
    input [3:0] d0, d1, d2, d3, 
    input [1:0] sel, 
    output [3:0] y);
    
    assign y = (sel == 2'b00) ? d0 : 
               (sel == 2'b01) ? d1 : 
               (sel == 2'b10) ? d2 : 
               d3;
endmodule