module top_module(
    input wire clk,   // clock signal
    input wire sel,   // select signal
    input wire in1,   // input signal 1
    input wire in2,   // input signal 2
    output reg out    // output signal changed to reg
);always @(posedge clk) begin
        if(sel == 1'b0) begin
            out <= in1;
        end else begin
            out <= in2;
        end
    end
endmodule