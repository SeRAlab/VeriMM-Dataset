module top_module( input [11:0]d,
                   input clk, rst, load, enabled,
                   output reg [11:0] contador);always @ (posedge clk)
begin
    if (rst)
        contador <= 12'b0;
    else if (load)
        contador <= d;
    if (enabled)
    begin
        if (contador == 12'd4095)
        contador <= 12'b0;
    else
        contador <= contador + 12'b000000000001;
    end
end


endmodule