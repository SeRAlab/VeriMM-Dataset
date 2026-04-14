module top_module(a, b, Sel, resultado);input[7:0]  a;
        input[7:0]  b;
        input       Sel;
        output reg [8:0]  resultado;

       
        always @(a, b, Sel)       begin
           if (Sel)
              resultado = a + b;
           else
              resultado = a - b;
        end
endmodule