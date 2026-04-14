module binary_counter (
  input clk, 
  input reset, 
  input [3:0] limit, 
  input [2:0] state, 
  output reg [2:0] next_state, 
  output reg [3:0] count, 
  output reg done);parameter IDLE=0, COUNTING=1, DONE=2;

    assign next_state[IDLE] = state[DONE] | (state[IDLE] & reset);
    assign next_state[COUNTING] = (state[IDLE] & ~reset) | (state[COUNTING] & (count != limit));
    assign next_state[DONE] = state[COUNTING] & (count == limit);

    always @(posedge clk or posedge reset) begin
        if (reset) 
            count <= 4'b0000;
        else if (state[COUNTING])
            count <= count + 1;
    end

    assign done = state[DONE];
    
endmodule