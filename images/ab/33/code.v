module top_module(output s,output cout, input a,input b,input cin);wire g,p,gout,pout,c0;
assign g= a&b;
assign p= a^b;

assign c0=cin;
assign pout=p;
assign gout=g;
    
assign s=p^c0;
assign cout=g|(cin&p);endmodule