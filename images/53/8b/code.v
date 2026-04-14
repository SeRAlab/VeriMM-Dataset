module top_module(A,B,C,D,a,b,c,d,e,f,g,com,test);input A; 
input B; 
input C; 
input D; 
output a; 
output b; 
output c; 
output d; 
output e; 
output f; 
output g; 
output com; 
output test;

assign a = !( (~B & ~D) | (~A & C) | (~A & B & D) | (B & C) | (A & ~D) | (A & ~B & ~C));
assign b = !( (A & ~C & D) | (~B) | (~A & ~C & ~D) | (~A & C & D));
assign c = !( (~C & D) | (~A & B) | (A & ~B) | (~A & ~C) | (~A & D));
assign d = !( (B & ~C & D) | (~B & C & D) | (B & C & ~D) | (A & ~C & ~D) | (~A & ~B & ~D));
assign e = !( (~B & ~D) | (C & ~D) | (A & C) | (A & B));
assign f = !( (~C & ~D) | (B & ~D) | (~A & B & ~C) | (A & ~B) | (A & C));
assign g = !( (~A & C) | (~A & B) | (B & D) | (C & ~D) | (A & ~B & ~C));
assign com = 0;
assign test = 0;
endmodule