module mux_2to1_8bit(a, b, sel, y);

    input  [7:0] a;  
    input  [7:0] b;  
    input  sel;
    output  [7:0] y;
    reg   [7:0]  y;

    always @(*)
          begin
            if (sel)
                y = b;
            else
                y = a;
          end  

endmodule