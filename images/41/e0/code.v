module top_module(
  input [n-1:0] in,
  input clk, // added clock input
  output reg [m-1:0] out // changed to reg to allow assignment
);parameter n = 4; // number of input signals
parameter m = 2; // number of output signals
parameter p = 3; // number of states

// define your inputs and outputs here
reg [1:0] state;
reg [1:0] next_state; // changed from wire to reg to allow assignment

// define the states and outputs of the machine
parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;

parameter O0 = 2'b00;
parameter O1 = 2'b01;
parameter O2 = 2'b10;

// define the state transition table
always @ (state or in) begin
  case (state)
    S0: begin
      if (in[0] && in[1]) begin
        next_state = S1;
      end else begin
        next_state = S0;
      end
    end
    S1: begin
      if (in[2]) begin
        next_state = S2;
      end else begin
        next_state = S1;
      end
    end
    S2: begin
      if (in[3]) begin
        next_state = S0;
      end else begin
        next_state = S2;
      end
    end
  endcase
end

// define the output signals as a function of the current state
always @ (state) begin
  case (state)
    S0: out = O0;
    S1: out = O1;
    S2: out = O2;
    default: out = O0; // added default case for safety
  endcase
end

// connect the inputs to the machine and transition from one state to another based on the inputs
always @ (posedge clk) begin
  state <= next_state;
end

endmodule