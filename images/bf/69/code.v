module mux_4bit_2to1(
    input [3:0] d0, d1,
    input sel,
    output [3:0] y);
    
    assign y = sel ? d1 : d0;
endmodule