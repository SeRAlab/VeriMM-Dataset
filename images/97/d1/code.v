module top_module(counter,i1,i2,i3);input [3:0] counter;
output i1,i2,i3;
reg i1,i2,i3;

always @(counter[1],counter[2],counter[3])
begin
i1=~counter[2]&(~counter[2])&(~counter[3]);
i2=(counter[2])&(~counter[3]);
i3=counter[3];
end
endmodule