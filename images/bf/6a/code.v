module top_module(head,tail,dest,head_init,tail_init,dest_init);input head_init,tail_init;
input [9:0] dest_init;
output reg head,tail;
output reg [9:0] dest;
always @(head_init or tail_init or dest_init)
begin
head=head_init;
tail=tail_init;
dest=dest_init;
end
endmodule