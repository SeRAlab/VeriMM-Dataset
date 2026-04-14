module top_module(
input wire variable, 
input wire sign,
output reg operation
);always @*
begin
    operation = ~(variable ^ sign);
end
endmodule