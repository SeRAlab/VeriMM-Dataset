module top_module(Inp, Out);input [25:0] Inp;
    reg [25:0] tmp;
    output reg [27:0] Out;

        always @(Inp) begin
             Out = Inp << 2;
             
         end

    
endmodule