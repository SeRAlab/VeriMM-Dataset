module top_module(
   input [3:0] in_signal,
   output reg [1:0] out_signal
);// Combinational logic to assign values to out_signal based on in_signal
always @(*) begin
    out_signal[0] = (in_signal <= 5) ? 1'b0 : 1'b1;
    out_signal[1] = (in_signal <= 10) ? 1'b0 : 1'b1;
end

endmodule