module top_module(p, g, c_in, c_out);input p, g, c_in; 
output reg c_out; 

always @(*) begin
    c_out = (p & c_in) | g; 
end
endmodule