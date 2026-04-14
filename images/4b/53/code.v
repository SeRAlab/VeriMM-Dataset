module top_module(
    input wire clk,

    input wire pulse_i,
    output wire pulse_o);reg [1:0] pulse_hist_ff;
always @(posedge clk) begin
    pulse_hist_ff <= {pulse_hist_ff[0], pulse_i};
end

assign pulse_o = (pulse_hist_ff == 2'b01);

endmodule