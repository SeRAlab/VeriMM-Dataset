module top_module(aclk, reset, enable, counter_out);input aclk;
    input reset;
    input enable;
    output reg [7:0] counter_out;

    always @(posedge aclk) begin
        if (reset) begin
            counter_out <= 8'b0;
        end else if (enable) begin
            counter_out <= counter_out + 1;
        end
    end

endmodule