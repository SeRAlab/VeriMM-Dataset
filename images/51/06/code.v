module top_module(

En, X, Ys

);input En;
input [1:0] X;
output reg [3:0] Ys;

always @ (X, En)
begin
    if (En != 0)
    begin
            case (X)
                2'd0:
                    Ys = 4'd1;
                2'd1:
                    Ys = 4'd2;
                2'd2:
                    Ys = 4'd4;
                2'd3:
                    Ys = 4'd8;
        
                default:
                    Ys = 4'd0;
            endcase
    end
    else
    begin
        Ys=0;
    end
end
 
endmodule