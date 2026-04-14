module top_module(
    input               clk,        // main clock
    input               rst,        // main reset
    input       [7:0]   data_in,    // input data
    input               enable,     // enable signal
    output reg  [7:0]   data_out    // output data
    );always @(posedge clk) begin
        if (rst) begin
            data_out <= 8'b0;
        end
        else if (enable) begin
            data_out <= data_in;
        end
    end
endmodule