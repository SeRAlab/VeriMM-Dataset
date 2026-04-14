module mux4to1(a, b, c, d, sel, y);  

    input  a, b, c, d;  
    input  [1:0] sel;  
    output  y;  
    reg   y;

    always @(*)
          begin
            case (sel)
                2'b00: y = a;
                2'b01: y = b;
                2'b10: y = c;
                2'b11: y = d;
                default: y = 0;
            endcase
          end  

endmodule