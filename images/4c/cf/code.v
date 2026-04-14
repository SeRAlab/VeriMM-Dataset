module top_module(
  input clk, // clock
  input in, // input bit
  input nreset, // async active low reset
  output reg detected // output signal, changed to reg
);reg [3:0] state; // state variable to keep track of sequence detection

  always @(posedge clk or negedge nreset) begin
    if (!nreset) begin
      state <= 4'b0; // reset state to initial state
      detected <= 1'b0; // reset output
    end else begin
      case (state)
        4'b0000: if (in == 1'b1) state <= 4'b0001; // detected 1
                 else state <= 4'b0000; // reset
        4'b0001: if (in == 1'b0) state <= 4'b0010; // detected 10
                 else if (in == 1'b1) state <= 4'b0001; // detected 1
                 else state <= 4'b0000; // reset
        4'b0010: if (in == 1'b1) state <= 4'b0011; // detected 101
                 else state <= 4'b0000; // reset
        4'b0011: if (in == 1'b0) state <= 4'b0100; // detected 1010
                 else if (in == 1'b1) state <= 4'b0001; // detected 1
                 else state <= 4'b0000; // reset
        4'b0100: begin // sequence detected
                   detected <= 1'b1; // set output
                   state <= 4'b0100; // stay in state
                 end
        default: state <= 4'b0000; // default case resets the state
      endcase
    end
  end

endmodule