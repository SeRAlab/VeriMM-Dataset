module top_module(clock, YAxis, meteor, move, METEOR_F);input clock;
input [15:0]YAxis;
input [15:0]meteor;
input [15:0]move;









output METEOR_F;


assign METEOR_F = meteor & (YAxis + move);












endmodule