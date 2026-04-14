module top_module( select, d, q );input select;
input[1:0] d;
output     q;

reg       q;
wire	  select;
wire[1:0] d;

always @( select or d )
begin
   case( select )
       0 : q = d[0];
       1 : q = d[1];
   endcase
end

endmodule