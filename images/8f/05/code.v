module binary_2bit_counter (
  input clk, 
  input reset, 
  input [2:0] state, 
  output reg [2:0] next_state, 
  output reg [1:0] count, 
  output reg done);parameter INIT=0, INCREMENT=1, DONE=2;

    assign next_state[INIT] = state[DONE] | (state[INIT] & reset);
    assign next_state[INCREMENT] = state[INIT] & ~reset;
    assign next_state[DONE] = (state[INCREMENT] & (count == 2'b11));

    always @(posedge clk or posedge reset) begin
        if (reset) 
            count <= 2'b00;
        else if (state[INCREMENT])
            count <= count + 1;
    end

    assign done = state[DONE];
    
endmodule