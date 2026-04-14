module top_module(
  input ctrl,
  output reg out // Change 'wire' to 'reg' since it will be driven in an always block
);parameter n = 4; // number of stages in the ring oscillator

reg [n-1:0] stages; // register to hold the state of each stage
wire feedback; // wire to connect the output of the last stage to the input of the first stage

// instantiate D flip-flops for each stage
generate
  genvar i;
  for (i = 0; i < n; i = i + 1) begin : stage
    reg d;
    always @(posedge feedback or negedge ctrl) begin
      if (~ctrl) begin
        d <= stages[i];
      end else begin
        d <= ~stages[i];
      end
    end
    assign feedback = (i == 0) ? d : stages[i-1];
    assign stages[i] = d;
  end
endgenerate

// divide the frequency of the output signal based on the value of the control signal
reg [31:0] counter = 0;
wire [31:0] threshold = (ctrl) ? 100000 : 200000;

always @(posedge feedback) begin
  if (counter == threshold - 1) begin
    counter <= 0;
    out <= ~out; // This is now valid since 'out' is declared as reg
  end else begin
    counter <= counter + 1;
  end
end

endmodule