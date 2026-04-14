module top_module(OUTPUT, clock, reset);output reg [2:0] OUTPUT;
  input clock, reset;
  reg [2:0] COUNT;
  
  always @(posedge clock)
  begin
    if(reset)
      COUNT <= 0;
    else if (COUNT == 6)
      COUNT <= 0;
    else
      COUNT <= COUNT + 1;
  end
  
  always @(COUNT)
  begin
    case(COUNT)
      3'b000 : OUTPUT <= 3'b000;
      3'b001 : OUTPUT <= 3'b001;
      3'b010 : OUTPUT <= 3'b010;
      3'b011 : OUTPUT <= 3'b011;
      3'b100 : OUTPUT <= 3'b110;
      3'b101 : OUTPUT <= 3'b101;
      3'b110 : OUTPUT <= 3'b111;
    endcase
  end
  
endmodule