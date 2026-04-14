module top_module(c);input [9:0] c;

function integer a(input integer b);
    begin
        a = b+1;
    end
endfunction

localparam f = 5;
wire [a(f)-1:0] d;

assign d = c[a(f)-1:0]; 
localparam e = a(f);


endmodule