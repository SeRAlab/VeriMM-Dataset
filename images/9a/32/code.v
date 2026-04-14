module top_module(input clk, input set, input reset, input [7:0] data_in, output reg [7:0] data_out);always @(posedge clk, posedge set, posedge reset) begin
    if (set) begin
        data_out <= 8'hFF; // set data_out to all 1's
    end else if (reset) begin
        data_out <= 8'h00; // set data_out to all 0's
    end else begin
        data_out <= data_in; // latch data_in to data_out
    end
end

endmodule