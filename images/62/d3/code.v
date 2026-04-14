module elevator_controller (
  input up, 
  input down, 
  input [2:0] state, 
  output reg [2:0] next_state, 
  output reg [1:0] floor);parameter GROUND=0, FIRST=1, SECOND=2;

    assign next_state[GROUND] = state[FIRST] & down;
    assign next_state[FIRST] = (state[GROUND] & up) | (state[SECOND] & down);
    assign next_state[SECOND] = state[FIRST] & up;

    assign floor = (state[GROUND]) ? 2'b00 : (state[FIRST]) ? 2'b01 : 2'b10;
    
endmodule