module top_module(switch, led);input  wire [7:0] switch;        
output wire [7:0] led;           




assign led[0] = switch[0] ^ switch[1];
assign led[1] = &switch;
assign led[7:2] = switch[4] ? (switch[3] ? 6'b010101 : 6'b111111) : (switch[2] ? 6'b101010 : 6'b000000);

endmodule