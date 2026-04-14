module top_module(data, ss, out);input wire [3:0] data;
input wire [1:0] ss;
output reg out;



always @ (*)
begin
    if (ss  == 2'b00)
    out = data [0];
    else if (ss == 2'b01)
    out = data [1];
    else if (ss == 2'b10)
    out = data [2];
    else if (ss == 2'b11)
    out = data [3];
    else out = 1'bz; 
end 



endmodule