module top_module(IN1,IN3,IN2,IN5,IN4,OUT);input IN1;
input IN3;
input IN2;
input IN5;
input IN4;
assign OUT = IN1 | IN2 | IN3 | IN4 | IN5;
output OUT;endmodule