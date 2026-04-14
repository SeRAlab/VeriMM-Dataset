module top_module(
  input clk, // clock input
  input rst, // synchronous reset input
  input set, // asynchronous set input
  input [3:0] load, // parallel load input
  output reg [3:0] Q, // 4-bit register output
  output reg [3:0] Qn // inverted output
);always @(posedge clk or negedge rst) begin
    if (!rst) begin // synchronous reset
      Q <= 4'b0;
    end else if (set) begin // asynchronous set
      Q <= 4'b1111;
    end else if (load != 4'b0) begin // parallel load
      Q <= load;
    end else begin // hold state
      Q <= Q;
    end
  end
  
  assign Qn = ~Q; // inverted output
  
endmodule