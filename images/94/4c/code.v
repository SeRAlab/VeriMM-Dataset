module top_module(a,b,saidaULA,Tula);input wire [3:0] a;
    input wire [3:0] b;
    input wire [2:0] Tula;
    
    output reg [3:0] saidaULA;

    parameter
    ADD = 3'd0;

    always @(Tula or a or b)
    begin
        case(Tula)
           ADD : saidaULA = a+b;
        endcase
    end
endmodule