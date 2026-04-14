module top_module(
    input divider_begin,
    input [1:0]sign,
    input [31:0]a,
    input [31:0]b,
    output[63:0]z,  
    output divider_end

);assign  divider_end =  ~a & ~b;

reg [31:0]_hi,_lo;
always @(*)
begin
if(divider_begin)
    if(sign == 1)
        begin
            _hi =  $signed(a)% $signed(b);
            _lo = $signed(a) / $signed(b);
        
        end
   else if(sign == 2)
        begin
            _hi = a%b;
            _lo = a/b;
         end
end
assign  z = {_hi,_lo};
endmodule