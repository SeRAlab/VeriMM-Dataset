module top_module(
    input [3:0] ain,
    input [3:0] bin,
    output reg cout,
    output reg [3:0] sum
    );task add_two_values;
        input [3:0] ain;
        input [3:0] bin;
        output cout;
        output [3:0] sum;
        {cout, sum} = ain + bin;
    endtask
    
    always @(ain or bin) begin
        add_two_values(ain, bin, cout, sum);
    end
endmodule