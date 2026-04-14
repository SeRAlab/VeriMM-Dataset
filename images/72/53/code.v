module top_module(
    input clk, rst,
    output reg [3:0] counter_output
);always@ (posedge clk) begin 
        if( rst | counter_output == 4'b1001)
            counter_output <= 4'b0000;
        else
            counter_output <= counter_output + 1;
    end
endmodule