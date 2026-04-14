module binary_updown_counter (
  input clk, 
  input reset, 
  input up, 
  input [3:0] limit, 
  input [3:0] state, 
  output reg [3:0] next_state, 
  output reg [3:0] count, 
  output reg done);parameter IDLE=0, COUNTUP=1, COUNTDOWN=2, DONE=3;

    assign next_state[IDLE] = state[DONE] | (state[IDLE] & reset);
    assign next_state[COUNTUP] = (state[IDLE] & ~reset & up) | (state[COUNTUP] & (count != limit));
    assign next_state[COUNTDOWN] = (state[IDLE] & ~reset & ~up) | (state[COUNTDOWN] & (count != 0));
    assign next_state[DONE] = (state[COUNTUP] & (count == limit)) | (state[COUNTDOWN] & (count == 0));

    always @(posedge clk or posedge reset) begin
        if (reset) 
            count <= 4'b0000;
        else if (state[COUNTUP])
            count <= count + 1;
        else if (state[COUNTDOWN])
            count <= count - 1;
    end

    assign done = state[DONE];
    
endmodule